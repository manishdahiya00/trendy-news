module Admin
  class DashboardController < Admin::AdminController
    before_action :authenticate_user!
    layout "admin"

    def index
      @users = User.count
      @news = Article.count
      @categories = Category.count
      @saved = Saved.count
      @app_banners = AppBanner.count
      @ft_app_users = FtAppUser.count
    end
  end
end
