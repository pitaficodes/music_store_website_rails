class RegistrationsController < Devise::RegistrationsController
  layout "application"
  respond_to :html, :js
  def new
    resource = build_resource({})
    respond_with resource
  end

  def create
    build_resource params[:user]
    resource.sign_up_ip = request.remote_ip
    if resource.save
      cookies[:user_signup_cookie] = true
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        set_flash_message :notice, :success
        UserMailer.welcome_email(params[:user][:email]).deliver
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      flash[:notice] = resource.errors.full_messages
      respond_with resource
    end
  end
  def update
    # required for settings form to submit when password is left blank
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    @user = current_user

    @user.subscription.update_attributes sub_type: params[:category] , category: params[:category] unless params[:category].blank?

    if @user.update_attributes(params[:user])
      set_flash_message :notice, :updated
      unless params[:category].blank?
        flash[:notice] = "You have successfully updated your profile and subscription plan."
        SubscriptionMailer.subscription_plan_changed(current_user).deliver
      else
        flash[:notice] = "You have successfully updated your profile."
      end
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to edit_user_registration_path
    else
      render "edit"
    end
  end


end
