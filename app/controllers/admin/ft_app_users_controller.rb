class Admin::FtAppUsersController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @users = FtAppUser.all.paginate(page: params[:page], per_page: 15).order(created_at: :desc)
    @newSignup = FtAppUser.where("created_at >= ?", Time.zone.now.beginning_of_day).count
  end

  def show
    @user = FtAppUser.find(params[:id])
    @appOpens = FtAppOpen.where(ft_app_user_id: @user.id).paginate(page: params[:page], per_page: 15).order(created_at: :desc).limit(10)
  end
end
