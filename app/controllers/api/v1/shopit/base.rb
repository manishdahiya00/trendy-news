module API
  module V1
    module Shopit
      class Base < Grape::API
        mount API::V1::Shopit::Auth
        mount API::V1::Shopit::Appuser
      end
    end
  end
end
