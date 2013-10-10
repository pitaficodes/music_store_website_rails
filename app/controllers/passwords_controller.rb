class PasswordsController < Devise::PasswordsController
  layout :resolve_layout
  respond_to :html, :js

  def new
    build_resource({})
  end

  def create
    if params[:robotest] && params[:robotest].blank?
      @recaptcha = true
      super
    else
      @recaptcha = false
      build_resource
      clean_up_passwords(resource)
      flash[:notice] = "You are a gutless robot."
      respond_with(resource)
    end
  end

  def show_answer_question

  end

  def answer_question
    if(params[:user][:question_id]!="" and params[:user][:answer]!="" and params[:reset_password_token]!="")
      user = User.where("question_id = ? AND answer = ? AND reset_password_token = ?", params[:user][:question_id], params[:user][:answer], params[:reset_password_token])
       if !user.empty?
         cookies[:user_pass_cookie] = { :value => true, :expires => 5.minutes.from_now }
         flash[:notice] = "1"
         @path = "/#{I18n.default_locale}/#{user.map(&:id).join()}/users/password/edit?reset_password_token=#{params[:reset_password_token]}"
       else
         flash[:notice] = "Incorrect Answer"
       end
    else
      flash[:notice] = "Incorrect Answer"
    end

  end

  def check_old_pass
    user = User.find(params[:id])
    u = user.valid_password?(params[:value])
    respond_to do |format|
      format.html { render :json => u }
    end
  end

  def edit
    if cookies[:user_pass_cookie]!="true"
      redirect_to  "/#{I18n.default_locale}/show_answer_question?reset_password_token=#{params[:reset_password_token]}"
    else
      self.resource = resource_class.new
      resource.reset_password_token = params[:reset_password_token]
    end
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.save
      UserMailer.reset_password(resource.email).deliver
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)
      cookies.delete :user_pass_cookie
      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      respond_with resource
    end
  end

  private

  def resolve_layout
    case action_name
      when "new", "create","answer_question","check_old_pass"
        false
      when "edit" , "update","show_answer_question"
        "static"
      else
        "static"
    end
  end
end