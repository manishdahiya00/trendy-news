module Shopit
  class Admin::ShopitCategoriesController < Admin::AdminController
    before_action :authenticate_user!
    layout "shopit_admin"

    def index
      @categories = ShopitCategory.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
    end

    def show
      @category = ShopitCategory.find_by(id: params[:id])
    end

    def new
      @category = ShopitCategory.new
    end

    def create
      @category = ShopitCategory.new(category_params)
      if @category.save
        redirect_to shopit_admin_shopit_categories_path
      else
        render :new
      end
    end

    def edit
      @category = ShopitCategory.find_by(id: params[:id])
    end

    def update
      @category = ShopitCategory.find_by(id: params[:id])
      if @category.update(category_params)
        redirect_to shopit_admin_shopit_categories_path
      else
        render :edit
      end
    end

    def destroy
      @category = ShopitCategory.find_by(id: params[:id])
      @category.destroy
      redirect_to shopit_admin_shopit_categories_path
    end

    def products
      @products = Product.where(shopit_category_id: params[:id]).paginate(page: params[:page], per_page: 20).order(created_at: :desc)
    end

    private

    def category_params
      params.require(:shopit_category).permit(:name, :image_url, :status)
    end
  end
end
