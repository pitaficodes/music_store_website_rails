class UsersController < ApplicationController

  def profile
    @user= current_user
  end

  def freeuser
    if User.find_all_by_sign_up_ip(request.remote_ip).present? || cookies[:user_signup_cookie]
      @message = "failure"
    else
      if User.find_by_email(params[:user_email][:email]).present?
        @message = "failure"
      else
        reserve = ReserveUser.find_or_create_by_email email: params[:user_email][:email]
        FreeUserMailer.freeuser( params[:user_email][:email] ,  params[:ref] , reserve.id ).deliver
        @message = "success"
      end
    end
  end

  def update_password
    user = current_user
    if current_user.valid_password? params[:user][:current_password]
      params[:user].delete(:current_password)
      if current_user.update_attributes params[:user]
        @success = 1
        sign_in user, bypass: true
      else
        @success = 0
      end
    else

    end
  end

end
