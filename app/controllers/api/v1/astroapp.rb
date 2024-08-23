module API
  module V1
    class Astroapp < Grape::API
      include API::V1::Defaults
      helpers do
        def valid_appuser(user_id,security_token)
            user = AstrologyUser.where("id = ? AND security_token = ?", user_id, security_token).first
            if user
              return user
            else
              return false
            end
        end

        def google_validator(token, socialemail)
            validator = GoogleIDToken::Validator.new(expiry: 300)
            begin
              token_segments = token.split('.')
              if token_segments.count == 3
                #optional_client_id = 473754589992-sp8t4j084skt894hb2gvc6mno2933qs7.apps.googleusercontent.com'
                required_audience = JWT.decode(token, nil, false)[0]['aud']
                payload = validator.check(token, required_audience)
                #payload = validator.check(token, required_audience, optional_client_id)
                Rails.logger.info "++Payload Email:#{payload['email']}|ApiEmail:#{socialemail}"
                Rails.logger.info "Payload Params:#{payload}"
                if(payload['email'] == socialemail) # && (payload['azp'].include? "473754589992")
                  return true
                else
                  return false
                end
              else
                return false
              end
            rescue GoogleIDToken::ValidationError => e
              Rails.logger.info "++Validator Error:#{e}"
              return false
            end
          end
      end

    	##################################################################
      # => V1 User Sign Up Api
      ##################################################################
      resource :asuserSignup do
        before {api_params}

        params do
          requires :deviceId, type: String, allow_blank: false
          optional :deviceType, type: String, allow_blank: true
          optional :deviceName, type: String, allow_blank: true

          requires :socialType, type: String, allow_blank: false
          requires :socialId, type: String, allow_blank: false
          optional :socialToken, type: String, allow_blank: false

          optional :socialEmail, type: String, allow_blank: true
          optional :socialName, type: String, allow_blank: true
          optional :socialImgurl, type: String, allow_blank: true

          optional :advertisingId, type: String, allow_blank: true
          requires :versionName, type: String, allow_blank: false
          requires :versionCode, type: String, allow_blank: false

          optional :utmSource, type: String, allow_blank: true
          optional :utmMedium, type: String, allow_blank: true
          optional :utmTerm, type: String, allow_blank: true
          optional :utmContent, type: String, allow_blank: true
          optional :utmCampaign, type: String, allow_blank: true
        end

        post do
          begin
            source_ip = env['REMOTE_ADDR'] || env['HTTP_X_FORWARDED_FOR']
            location_ip = env['HTTP_X_FORWARDED_FOR'] || env['REMOTE_ADDR']

            genuine_user = google_validator(params['socialToken'], params['socialEmail'])
            if genuine_user == false
              Rails.logger.info "API Exception-BLOCK-GLV:#{Time.now}-asuserSignup-#{params.inspect}"
              {message: GBLOCKED, status: 500}
            else
              source_ip_count = AstrologyUser.where(source_ip: source_ip).count
              location_ip_count = AstrologyUser.where(location: location_ip).count

              if source_ip_count > MAX_IP_COUNT
                Rails.logger.info "API Exception-BLOCK-IPS:#{Time.now}-asuserSignup-#{params.inspect}"
                {message: BLOCKED, status: 500}
              elsif location_ip_count > MAX_IP_COUNT
                Rails.logger.info "API Exception-BLOCK-IPL:#{Time.now}-asuserSignup-#{params.inspect}"
                {message: BLOCKED, status: 500}
              else
                user = AstrologyUser.where(social_id: params['socialId']).first_or_initialize
                refCode = SecureRandom.hex(4).upcase
                utm_medium = params['utmMedium']

                if user.new_record?
                  user.update(referral_code: refCode, social_email: params['socialEmail'], social_type: params['socialType'],
                   social_name: params['socialName'], social_imgurl: params['socialImgurl'], device_type: params['deviceType'],
                   device_name: params['deviceName'], advertising_id: params['advertisingId'], version_name: params['versionName'],
                   version_code: params['versionCode'], security_token: SecureRandom.uuid, fcm_token: params['fcmToken'], social_token: params['referrerUrl'],
                   device_id: params['deviceId'], location: location_ip, source_ip: source_ip, utm_source: params['utmSource'], utm_medium: utm_medium)
                else
                  user.update(social_id: params['socialId'], social_email: params['socialEmail'], social_type: params['socialType'],
                   social_name: params['socialName'], social_imgurl: params['socialImgurl'], device_type: params['deviceType'],
                   device_name: params['deviceName'], advertising_id: params['advertisingId'], version_name: params['versionName'],
                   version_code: params['versionCode'], fcm_token: params['fcmToken'], social_token: params['referrerUrl'],
                   device_id: params['deviceId'], location: location_ip, source_ip: source_ip, utm_source: params['utmSource'], utm_medium: params['utmMedium'])
                end
                {status: 200, message: MSG_SUCCESS, userId: user.id, securityToken: user.security_token}
              end
            end
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-asuserSignup-#{params.inspect}-Error-#{e}"
            {message: MSG_ERROR, status: 500}
          end
        end
      end

      ##################################################################
      # => V1 user App Open API
      ##################################################################
      resource :asappOpen do
        before {api_params}

        params do
          requires :userId, type: String, allow_blank: false
          requires :securityToken, type: String, allow_blank: false
          requires :versionName, type: String, allow_blank: false
          requires :versionCode, type: String, allow_blank: false
        end

        post do
          begin
            user = valid_appuser(params['userId'].to_i, params['securityToken'])
            if user
              force_update = false
              source_ip = env['REMOTE_ADDR'] || env['HTTP_X_FORWARDED_FOR']
              location = source_ip #Geocoder.address(source_ip)
              active_banner = AstrologyAppBanner.active.sample
              custom_ad = {image_url: active_banner.img_url, action_url: active_banner.action_url}
              app_url = "Hey, I just found out my future using Horoscope. You can find yours too at this amazing app try out! https://play.google.com/store/apps/details?id=com.horoscopes.android"
              user.astrology_appopens.new(source_ip: source_ip, location: location, version_name: params['versionName'], version_code: params['versionCode']).save!
              {message: MSG_SUCCESS, status: 200, forceUpdate: force_update, appUrl: app_url, customAd: custom_ad}
            else
              {message: INVALID_USER, status: 500}
            end
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-asappOpen-#{params.inspect}-Error-#{e}"
            {message: MSG_ERROR, status: 500}
          end
        end
      end


      ##################################################################
      # => V1 user profile API
      ##################################################################
      resource :asuserProfile do
        before {api_params}

        params do
          requires :userId, type: String, allow_blank: false
          requires :securityToken, type: String, allow_blank: false
          requires :versionName, type: String, allow_blank: false
          requires :versionCode, type: String, allow_blank: false
          requires :actionType, type: String, allow_blank: false
          optional :name, type: String, allow_blank: false
          optional :date_of_birth, type: String, allow_blank: false
          optional :gender, type: String, allow_blank: false
          optional :location, type: String, allow_blank: false
        end

        post do
          begin
            user = valid_appuser(params['userId'].to_i, params['securityToken'])
            if user
              if params['actionType'] == 'POST'
                user_profile = AstrologyUserProfile.where(astrology_user_id: user.id).first_or_initialize
                user_profile.update(name: params['name'], gender: params['gender'], date_of_birth: params['date_of_birth'], location: params['location'])
                {message: MSG_SUCCESS, status: 200, userProfile:"Profile Submitted!"}
              else
                user_profile = AstrologyUserProfile.where(astrology_user_id: user.id).last
                if user_profile.present?
                	{message: MSG_SUCCESS, status: 200, userName: user_profile.name, userEmail: user.social_email,
                    gender: user_profile.gender, location: user_profile.location, birthDate: user_profile.date_of_birth, socialImgurl: user.social_imgurl}
                else
                	{message: MSG_SUCCESS, status: 200, userName: user.social_name, userEmail: user.social_email,
                    gender: '', location: '', birthDate: '', socialImgurl: user.social_imgurl}
                end
              end
            else
              {message: INVALID_USER, status: 500}
            end
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-asuserProfile-#{params.inspect}-Error-#{e}"
            {message: MSG_ERROR, status: 500}
          end
        end
      end

      ##################################################################
      # => V1 app get info api
      ##################################################################
      resource :getInfo do
        before {api_params}
        params do
          requires :userId, type: String, allow_blank: false
          requires :securityToken, type: String, allow_blank: false
          requires :versionName, type: String, allow_blank: false
          requires :versionCode, type: String, allow_blank: false
          requires :sign, type: String, allow_blank: false
        end
        post do
          begin
            user = valid_appuser(params['userId'].to_i, params['securityToken'])
            if user
            	@astro_records = Astrology.where(sign: params[:sign].downcase).order('id desc').last(3)

              ystrdy_astr = @astro_records.last
              yesterday_astrology = {luckyTime: ystrdy_astr.lucky_time, luckyNumber: ystrdy_astr.lucky_number, color: ystrdy_astr.color, mood: ystrdy_astr.mood, description: ystrdy_astr.description}

              tody_astr = @astro_records.second
              today_astrology = {luckyTime: tody_astr.lucky_time, luckyNumber: tody_astr.lucky_number, color: tody_astr.color, mood: tody_astr.mood, description: tody_astr.description}

              tmrw_astr = @astro_records.first
              tomorrow_astrology = {luckyTime: tmrw_astr.lucky_time, luckyNumber: tmrw_astr.lucky_number, color: tmrw_astr.color, mood: tmrw_astr.mood, description: tmrw_astr.description}

              {message: MSG_SUCCESS, status: 200, yesterday: yesterday_astrology , today: today_astrology, tomorrow: tomorrow_astrology}
            else
              {message: INVALID_USER, status: 500}
            end
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-getInfo-#{params.inspect}-Error-#{e}"
            {message: MSG_ERROR, status: 500}
          end
        end
      end

      ##################################################################
      # => V1 Invite Page
      ##################################################################
      resource :userappInvite do
        before {api_params}
        params do
          requires :userId, type: String, allow_blank: false
          requires :securityToken, type: String, allow_blank: false
          requires :versionName, type: String, allow_blank: false
          requires :versionCode, type: String, allow_blank: false
        end
        post do
          begin
            user = valid_appuser(params['userId'].to_i, params['securityToken'])
            if user
              inviteFbUrl = "https://mobnews.app/appinvite/#{user.referral_code}/?by=facebook"
              inviteText = "Share & Invite Friends on TrendyNews and get all latest updates around the globe!"
              inviteTextUrl = "Download TrendyNews App - Get All latest news abount country, sports, entertainment & Business at one place"

              {message: MSG_SUCCESS, status: 200, inviteFbUrl: inviteFbUrl, inviteTextUrl: inviteTextUrl, inviteText: inviteText}
            else
              {message: INVALID_USER, status: 500}
            end
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-appInvite-#{params.inspect}-Error-#{e}"
            {message: MSG_ERROR, status: 500}
          end
        end
      end
    end
  end
end
