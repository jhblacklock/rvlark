module ApplicationHelper
  def avatar_url(user)
    user.image
  end

  def custom_bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      type = 'success' if type == 'notice'
      type = 'error'   if type == 'alert'
      text = "<script>toastr.#{type}('#{message}');</script>"
      flash_messages << text.html_safe if message
    end
    flash_messages.join("\n").html_safe
  end

  def gravatar(user)
    gravatar_id = Digest::MD5.hexdigest(user.email).downcase
    "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identical&s=150"
  end

  def body_class
    qualified_controller_name = controller.controller_path.tr('/', '-')
    logged_in = user_signed_in? ? 'logged_in' : 'public'
    "#{qualified_controller_name} #{qualified_controller_name}_#{controller.action_name} #{logged_in}"
  end

  def resource_name
    :user
  end

  def resource_class
    User
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
