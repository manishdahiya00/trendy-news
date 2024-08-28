class AcdeleteController < ApplicationController
  def new
    @deleted_user = DeletedUser.new
  end

  def create
    @user = find_user_by_email_and_platform(user_params[:email], user_params[:from])
    puts user_params[:email]
    puts user_params[:from]
    if @user.present?
      @existing_deleted_user = DeletedUser.find_by(email: user_params[:email], from: user_params[:from])
      if @existing_deleted_user.present?
        flash[:alert] = "User deletion request already sent."
        redirect_to "/acdelete?ap=#{user_params[:from]}"
      else
        @deleted_user = DeletedUser.new(user_params)
        if @deleted_user.save
          flash[:alert] = "User deletion request submitted successfully"
          redirect_to "/acdelete?ap=#{user_params[:from]}"
        else
          flash[:alert] = @deleted_user.errors.full_messages.to_sentence
          redirect_to "/acdelete?ap=#{user_params[:from]}"
        end
      end
    else
      flash[:alert] = "No user associated with this email address"
      redirect_to "/acdelete?ap=#{user_params[:from]}"
    end
  end

  private

  def user_params
    params.require(:deleted_user).permit(:email, :from)
  end

  def find_user_by_email_and_platform(email, platform)
    case platform
    when "astro"
      AstrologyUser.find_by(social_email: email)
    when "mobn"
      User.find_by(social_email: email, user_from: "MobNews")
    when "trendy"
      User.find_by(social_email: email, user_from: "TrendyNews")
    when "fastag"
      FtAppUser.find_by(social_email: email)
    else
      nil
    end
  end
end
