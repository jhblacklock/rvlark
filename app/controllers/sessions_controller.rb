# app/controllers/sessions_controller.rb
class SessionsController < Devise::SessionsController
  respond_to :js

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)

    render_success
  end

  def render_success
    render json: after_sign_in_path_for(resource).to_json, status: :ok
  end
end
