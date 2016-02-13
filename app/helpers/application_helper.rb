module ApplicationHelper
  def avatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    if user.image
      user.image
    else
      "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identical&s=150"
    end
  end

  def body_class
    qualified_controller_name = controller.controller_path.gsub('/', '-')
    logged_in = user_signed_in? ? 'logged_in' : 'public'
    "#{qualified_controller_name} #{qualified_controller_name}_#{controller.action_name} #{logged_in}"
  end
end
