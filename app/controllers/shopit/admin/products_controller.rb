module Shopit
  class Admin::ProductsController < Admin::AdminController
    before_action :authenticate_user!
    layout "shopit_admin"

    def index
      @products = Product.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
    end

    def show
      @product = Product.find_by(id: params[:id])
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        redirect_to shopit_admin_products_path
      else
        render :new
      end
    end

    def edit
      @product = Product.find_by(id: params[:id])
    end

    def update
      @product = Product.find_by(id: params[:id])
      if @product.update(product_params)
        redirect_to shopit_admin_products_path
      else
        render :edit
      end
    end

    def destroy
      @product = Product.find_by(id: params[:id])
      @product.destroy
      redirect_to shopit_admin_products_path
    end

    private

    def product_params
      params.require(:product).permit(:name, :image_url, :status, :shopit_category_id, :description, :no_of_items, :price, :discount)
    end
  end
end
