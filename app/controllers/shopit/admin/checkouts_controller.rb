module Shopit
  class Admin::CheckoutsController < Admin::AdminController
    before_action :authenticate_user!
    layout "shopit_admin"

    def index
      @checkouts = Checkout.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
    end

    def show
      @cart_items = Order.where(checkout_id: params[:id]).order(created_at: :desc)
      product_ids = @cart_items.pluck(:product_id).map(&:to_i)
      @products = Product.where(id: product_ids)
      @checkout = Checkout.find(params[:id])
      @order_id = @checkout.order_id
    end

    def edit
      @checkout = Checkout.find_by(id: params[:id])
    end

    def update
      @checkout = Checkout.find_by(id: params[:id])
      if @checkout.update(checkout_params)
        redirect_to shopit_admin_checkouts_path
      else
        render :edit
      end
    end

    def destroy
      @checkout = Checkout.find_by(id: params[:id])
      @checkout.destroy
      redirect_to shopit_admin_checkouts_path
    end

    private

    def checkout_params
      params.require(:checkout).permit(:status, :name, :email, :mobile, :order_status)
    end
  end
end
