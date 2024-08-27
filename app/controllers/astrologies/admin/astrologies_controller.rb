module Astrologies
  class Admin::AstrologiesController < Admin::AdminController
    before_action :authenticate_user!
    layout "astrology_admin"

    def index
      @astrologies = Astrology.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
    end

    def destroy
      @astrology = Astrology.find(params[:id])
      @astrology.destroy
      redirect_to astrologies_admin_astrologies_path
    end
  end
end
