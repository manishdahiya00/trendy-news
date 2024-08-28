class MainController < ApplicationController
  def index
    if params[:deleteuser].present?
      @user = User.find_by(social_email: params[:deleteuser])
      if @user
        @user.destroy
      end
    end
  end
end
