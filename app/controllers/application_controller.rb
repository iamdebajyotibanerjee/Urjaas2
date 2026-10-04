class ApplicationController < ActionController::Base
  before_action :configure_two_factor_parameters, if: :devise_controller?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  protected

  # Redirect user to the dashboard route after sign in
  def after_sign_in_path_for(resource)
    return admin_two_factor_setup_path if resource.is_a?(User) && !resource.two_factor_enabled?

    landing_pages_path
  end

  def configure_two_factor_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :otp_attempt ])
  end
end
