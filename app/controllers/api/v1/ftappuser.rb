module API
  module V1
    class Ftappuser < Grape::API
      MSG_SUCCESS = "Success"
      MSG_ERROR = "Error"
      INVALID_USER = "User Not Found"
      prefix :api
      format :json
      version :v1

      helpers do
        def valid_user(userId, securityToken)
          FtAppUser.find_by(id: userId, security_token: securityToken)
        end

        params :common_params do
          requires :userId, type: String, allow_blank: false
          requires :securityToken, type: String, allow_blank: false
          requires :versionName, type: String, allow_blank: false
          requires :versionCode, type: String, allow_blank: false
        end

        def api_params
          Rails.logger.info "API Params:#{params.inspect}"
        end

        def google_validator(token, socialemail)
          validator = GoogleIDToken::Validator.new(expiry: 300)
          begin
            token_segments = token.split(".")
            if token_segments.count == 3
              required_audience = JWT.decode(token, nil, false)[0]["aud"]
              payload = validator.check(token, required_audience)
              if (payload["email"] == socialemail)
                return true
              else
                return false
              end
            else
              return false
            end
          rescue GoogleIDToken::ValidationError => e
            return false
          end
        end
      end

      resource :ftGoogleSignup do
        before { api_params }

        params do
          requires :deviceId, type: String, allow_blank: false
          requires :deviceType, type: String, allow_blank: false
          requires :deviceName, type: String, allow_blank: false
          requires :socialType, type: String, allow_blank: false
          requires :socialId, type: String, allow_blank: false
          requires :socialToken, type: String, allow_blank: false
          requires :socialEmail, type: String, allow_blank: false
          requires :socialName, type: String, allow_blank: false
          requires :socialImgUrl, type: String, allow_blank: false
          requires :advertisingId, type: String, allow_blank: false
          requires :userFrom, type: String, allow_blank: false
          requires :versionName, type: String, allow_blank: false
          requires :versionCode, type: String, allow_blank: false
          optional :utmSource, type: String, allow_blank: true
          optional :utmMedium, type: String, allow_blank: true
          optional :utmTerm, type: String, allow_blank: true
          optional :utmContent, type: String, allow_blank: true
          optional :utmCampaign, type: String, allow_blank: true
          optional :referalUrl, type: String, allow_blank: true
        end
        post do
          begin
            valid_user = google_validator(params[:socialToken], params[:socialEmail])
            if valid_user
              user = FtAppUser.find_by(social_email: params[:socialEmail], social_id: params[:socialId], user_from: params[:userFrom])
              source_ip = request.ip
              unless user.present?
                user = FtAppUser.create(device_id: params[:deviceId], device_type: params[:deviceType], device_name: params[:deviceName], social_type: params[:socialType], social_id: params[:socialId], social_email: params[:socialEmail], social_name: params[:socialName], social_img_url: params[:socialImgUrl], advertising_id: params[:advertisingId], version_name: params[:versionName], version_code: params[:versionCode], utm_source: params[:utmSource], utm_term: params[:utmTerm], utm_medium: params[:utmMedium], utm_content: params[:utmContent], utm_campaign: params[:utmCampaign], referrer_url: params[:referalUrl], source_ip: source_ip, security_token: SecureRandom.uuid, refer_code: SecureRandom.hex(6).upcase, user_from: params[:userFrom])
                { status: 200, message: MSG_SUCCESS, userId: user.id, securityToken: user.security_token }
              end
              user.update(device_id: params[:deviceId], device_type: params[:deviceType], device_name: params[:deviceName], social_type: params[:socialType], social_id: params[:socialId], social_email: params[:socialEmail], social_name: params[:socialName], social_img_url: params[:socialImgUrl], advertising_id: params[:advertisingId], version_name: params[:versionName], version_code: params[:versionCode], utm_source: params[:utmSource], utm_term: params[:utmTerm], utm_medium: params[:utmMedium], utm_content: params[:utmContent], utm_campaign: params[:utmCampaign], referrer_url: params[:referalUrl], source_ip: source_ip)
              { status: 200, message: MSG_SUCCESS, userId: user.id, securityToken: user.security_token }
            else
              { status: 500, message: "Sorry, Tricks are not allowed" }
            end
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-userSignUp-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR }
          end
        end
      end

      resource :ftDefaultUser do
        before { api_params }

        params do
          requires :email, type: String, allow_blank: false
          requires :password, type: String, allow_blank: false
          requires :versionName, type: String, allow_blank: false
          requires :versionCode, type: String, allow_blank: false
        end

        post do
          begin
            source_ip = request.ip
            if params[:email] == "testingyash8@gmail.com" && params[:password] == "yash@123"
              user = FtAppUser.find_by(social_email: params[:email])
              if user.present?
                { message: "Success", status: 200, userId: user.id, securityToken: user.security_token }
              else
                new_user = FtAppUser.create(social_name: "Testing Yash", social_email: params[:email], security_token: "acc7106fe5009609", source_ip: source_ip, refer_code: SecureRandom.hex(6).upcase, social_img_url: "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png")
                { message: "Success", status: 200, userId: new_user.id, securityToken: new_user.security_token }
              end
            else
              { status: 500, message: "Invalid Email Or Password" }
            end
          rescue Exception => e
            Rails.logger.info "API Exception - #{Time.now} - defaultUser - #{params.inspect} - Error - #{e}"
            { status: 500, message: MSG_ERROR }
          end
        end
      end

      resource :ftAppOpen do
        before { api_params }

        params do
          use :common_params
        end
        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            source_ip = request.ip
            forceUpdate = false
            user.app_opens.create(source_ip: source_ip, version_name: params[:versionName], version_code: params[:versionCode])
            { status: 200, message: MSG_SUCCESS, forceUpdate: forceUpdate, packageName: "com.mobnews.app", customAds: custom_ads }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-appOpen-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR }
          end
        end
      end
    end
  end
end
