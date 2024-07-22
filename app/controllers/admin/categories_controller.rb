class Admin::CategoriesController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @categories = Category.all.paginate(page: params[:page], per_page: 15).order(created_at: :desc)
  end
end
