module Shopit
  module Admin
    class DashboardController < Admin::AdminController
      before_action :authenticate_user!
      layout "shopit_admin"

      def index
        @users = ShopitUser.count
        @categories = ShopitCategory.count
        @products = Product.count
        @orders = Checkout.count
      end
    end
  end
end
