class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  protected

  # Redirect user to the dashboard route after sign in
  def after_sign_in_path_for(resource)
    landing_pages_path
  end
end
