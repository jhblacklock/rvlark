class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  after_filter :store_location

  # Devise overrides
  def store_location
    return unless request.get?
    if request.path != '/sign_in' &&
       request.path != '/sign_up' &&
       request.path != '/password/new' &&
       request.path != '/password/edit' &&
       request.path != '/confirmation' &&
       request.path != '/sign_out' &&
       !request.xhr? # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(_resource)
    request.env['omniauth.origin'] || session[:previous_url] || root_path
  end

  def after_sign_out_path_for(_resource)
    root_path
  end

  def authenticate_user!(_resource = nil)
    if user_signed_in?
      super
    else
      redirect_to root_path, alert: 'Sign in before continuing.'
    end
  end

  def sign_in_and_redirect(resource_or_scope, resource = nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(scope, resource) unless warden.user(scope) == resource
    render json: { success: true, redirect: after_sign_in_path_for(resource) }
  end
  ##

  def default_serializer_options
    { root: false }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :first_name << :last_name
    devise_parameter_sanitizer.for(:account_update) << :first_name << :phone_number << :description << :avatar
  end
end
