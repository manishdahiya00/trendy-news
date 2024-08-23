module API
  class Base < Grape::API
    mount API::V1::Auth
    mount API::V1::Newsappuser
    mount API::V1::Ftappuser
    mount API::V1::Astroapp
    mount API::V1::Shopit::Auth
    mount API::V1::Shopit::Appuser
  end
end
