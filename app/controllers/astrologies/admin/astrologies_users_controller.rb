module Astrologies
  class Admin::AstrologiesUsersController < Admin::AdminController
    before_action :authenticate_user!
    layout "astrology_admin"

    def index
      @users = AstrologyUser.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
    end

    def show
      @user = AstrologyUser.find(params[:id])
      @appOpens = @user.astrology_appopens.paginate(page: params[:page], per_page: 10).order(created_at: :desc)
    end
  end
end
