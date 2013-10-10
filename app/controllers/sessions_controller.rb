class SessionsController < Devise::SessionsController
  layout false
  respond_to :html, :js

  def new
    self.resource = build_resource(nil, :unsafe => true)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    a= cookies[:instrument]
    #if resource.password_reset?
    #  @redirection_path = edit_user_registration_path(password_reset: :true)
    #end
    #respond_with resource, :location => edit_user_password_path
    respond_with resource, :location => after_sign_in_path_for(resource) if resource.password_reset?
    #ajax redirection from create.js.erb
    if current_user
      if current_user.user_pieces.where("is_favourite = true").length >0
        @redirection_path =  personal_libraries_path(:pg_heading=>"Favorites",:instrument_id=>a)
      elsif current_user.user_pieces.length >0
        @redirection_path =  history_libraries_path(:pg_heading=>"History",:instrument_id=>a)
      else
        @redirection_path =  libraries_path(:instrument_id=>a)
        end
       end
    end
  end


