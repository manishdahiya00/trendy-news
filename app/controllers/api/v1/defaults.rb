module API
  module V1
    module Defaults
      extend Grape::API::Helpers

      MSG_SUCCESS = "Success"
      APIKEY = 'f4919ce87ada4fda8952163971ed9fb6'
      MSG_ERROR = "Internal Server Error"
      BLOCKED = "You Blocked, Max Limit"
      INVALID_USER = 'Invalid User Request'
      BASE_URL = "https://mobnews.app"
      NEWS_API = News.new("f4919ce87ada4fda8952163971ed9fb6")
      MAX_IP_COUNT = 2
      GBLOCKED = "Sorry! Scripts/Tricks not Allowed"

      def self.included(base)
        base.prefix :api
        base.version :v1
        base.format :json

        base.helpers do
          params :common_params do
            requires :userId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
          end

          def api_params
            Rails.logger.info "API Params:#{params.inspect}"
          end

          def valid_user(userId, securityToken)
            User.find_by(id: userId, security_token: securityToken)
          end
        end
      end
    end
  end
end
