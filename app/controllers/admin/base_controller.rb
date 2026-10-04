module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!
    before_action :require_two_factor!

    private

    def authorize_admin!
      return if current_user&.email&.casecmp?(User::ADMIN_EMAIL)

      head :forbidden
    end

    def require_two_factor!
      redirect_to admin_two_factor_setup_path unless current_user.two_factor_enabled?
    end
  end
end
