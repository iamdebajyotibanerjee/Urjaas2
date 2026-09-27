module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    private

    def authorize_admin!
      return if current_user&.email&.casecmp?(User::ADMIN_EMAIL)

      head :forbidden
    end
  end
end
