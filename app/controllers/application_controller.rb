class ApplicationController < ActionController::Base
  protect_from_forgery


  before_filter :set_locale
  before_filter :set_cache_buster
  #, :check_ref


  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  def default_url_options
    {:locale => I18n.locale}.merge!(params[:ref] ? {ref: params[:ref]} : {})
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && !params[:controller].include?("admin")
      current_user.password_reset? ? edit_user_registration_path(password_reset: :true) : request.env['omniauth.origin'] || libraries_path
    else
      admin_dashboard_path
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path
  end

  around_filter :bind_current_user

  def bind_current_user
    User.current = current_user if current_user.present?
    yield
    User.current = nil
  end

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def practice_address
    if current_user
      return personal_libraries_url(pg_heading: "Favorites") unless current_user.pieces.where("is_favourite = ? AND is_active = ?", true,true).blank?
      return history_libraries_url( pg_heading: "History" ) unless current_user.pieces.where("is_active = ?",true).blank?
      libraries_path
    else
      root_path
    end
  end


end
