class Admin::CategoriesController < Admin::AdminController
  before_action :authenticate_user!
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  layout "admin"

  def index
    @categories = Category.all.order(created_at: :desc).paginate(page: params[:page], per_page: 15)
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "Category was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Category was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: "Category was successfully destroyed."
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :color, :image_url, :status)
  end
end
