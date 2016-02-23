# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  respond_to :js

  def edit
    case params[:section]
    when 'photo'
      render :photo
    else
      render :edit
    end
  end

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        sign_in(resource_name, resource)
      else
        expire_data_after_sign_in!
      end
      render_success
    else
      clean_up_passwords resource
      set_minimum_password_length
      render json: signup_form, status: :unprocessable_entity
    end
  end

  protected

  def render_success
    render json: after_sign_in_path_for(resource).to_json, status: :ok
  end

  def signup_form
    render_to_string partial: 'shared/signup_form'
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    session[:previous_url] || edit_user_registration_path
  end
end
