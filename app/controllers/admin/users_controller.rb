class Admin::UsersController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @users = User.all.paginate(page: params[:page], per_page: 15).order(created_at: :desc)
    @newSignup = User.where("created_at >= ?", Time.zone.now.beginning_of_day).count
  end

  def show
    @user = User.find(params[:id])
    @appOpens = AppOpen.where(user_id: @user.id).paginate(page: params[:page], per_page: 15).order(created_at: :desc).limit(10)
    @savedNews = @user.saved.paginate(page: params[:page], per_page: 15).order(created_at: :desc)
  end
end
