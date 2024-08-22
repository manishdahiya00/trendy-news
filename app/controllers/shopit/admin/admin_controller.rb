module Shopit
  module Admin
    class AdminController < ApplicationController
      def authenticate_user!
        redirect_to shopit_admin_path unless current_user
      end

      def current_user
        session[:admin_authenticated] == true
      end
    end
  end
end
