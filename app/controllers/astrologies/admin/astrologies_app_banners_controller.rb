module Astrologies
  module Admin
    class AstrologiesAppBannersController < Admin::AdminController
      before_action :authenticate_user!
      layout "astrology_admin"

      def index
        @appBanners = AstrologyAppBanner.all.order("id DESC").paginate(:page => params[:page], :per_page => 10)
      end

      def show
        @appBanner = AstrologyAppBanner.find_by(id: params[:id])
      end

      def new
        @appBanner = AstrologyAppBanner.new
      end

      def create
        @appBanner = AstrologyAppBanner.new(app_banner_params)
        if @appBanner.save
          redirect_to astrologies_admin_astrologies_app_banners_path
        else
          render :new
        end
      end

      def edit
        @appBanner = AstrologyAppBanner.find_by(id: params[:id])
      end

      def update
        @appBanner = AstrologyAppBanner.find_by(id: params[:id])
        if @appBanner.update(app_banner_params)
          redirect_to astrologies_admin_astrologies_app_banners_path
        else
          render :edit
        end
      end

      def destroy
        @appBanner = AstrologyAppBanner.find_by(id: params[:id])
        @appBanner.destroy
        redirect_to astrologies_admin_astrologies_app_banners_path
      end

      private

      def app_banner_params
        params.require(:astrology_app_banner).permit(:img_url, :action_url, :status, :title)
      end
    end
  end
end
