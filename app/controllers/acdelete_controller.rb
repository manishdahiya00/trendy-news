class AcdeleteController < ApplicationController
  def new
  end

  def create
    @deleted_user = DeletedUser.new(user_params)
    if params[:ap] == "astro"
      @user = AstrologyUser.find_by(social_email: params[:email])
    elsif params[:ap] == "trendy"
      @user = User.find_by(social_email: params[:email], user_from: "")
    elsif params[:ap] == "mobn"
      @user = User.find_by(social_email: params[:email], user_from: "")
    elsif params[:ap] == "fastag"
      @user = FtAppUser.find_by(social_email: params[:email])
    end
    if @user.present?
      @deleted_user = DeletedUser.new(user_params)
      if @deleted_user.save
        redirect_to root_path, notice: "User deletion request submitted successfully"
      else
        redirect_to root_path, notice: "Something went wrong"
      end
    end
  end

  private

  def user_params
    params.require(:deleted_user).permit(:email, :from)
  end
end
