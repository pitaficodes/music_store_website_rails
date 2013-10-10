class ConfirmationsController < Devise::ConfirmationsController
  layout false
  respond_to :html, :js

  def new
    build_resource({})
  end

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)

    if successfully_sent?(resource)
      @sent = true
      flash[:notice] = t("devise.confirmations.send_instructions")
      respond_with({}, :location => after_resending_confirmation_instructions_path_for(resource_name))
    else
      @sent = false
      flash[:notice] = resource.errors.full_messages
      respond_with(resource)
    end
  end

  def show

    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_navigational_format?
      sign_in(resource_name, resource)
      UserMailer.welcome_email(resource.email).deliver
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
    end
  end

end
