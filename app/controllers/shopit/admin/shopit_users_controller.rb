module Shopit
  class Admin::ShopitUsersController < Admin::AdminController
    before_action :authenticate_user!
    layout "shopit_admin"

    def index
      @users = ShopitUser.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
    end

    def show
      @user = ShopitUser.find(params[:id])
      @appOpens = @user.shopit_app_opens.paginate(page: params[:page], per_page: 10).order(created_at: :desc)
    end
  end
end
