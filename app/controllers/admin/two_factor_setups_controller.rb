module Admin
  class TwoFactorSetupsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!
    before_action :redirect_if_two_factor_enabled

    def show
      ensure_otp_secret
      set_provisioning_uri
      response.headers["Cache-Control"] = "no-store"
    end

    def create
      ensure_otp_secret

      if current_user.validate_and_consume_otp!(params.dig(:two_factor_setup, :otp_attempt))
        current_user.update!(otp_required_for_login: true)
        redirect_to landing_pages_path, notice: "Two-factor authentication is enabled."
      else
        set_provisioning_uri
        flash.now[:alert] = "That code was not valid. Try the current code from your authenticator app."
        response.headers["Cache-Control"] = "no-store"
        render :show, status: :unprocessable_content
      end
    end

    private

    def authorize_admin!
      return if current_user&.email&.casecmp?(User::ADMIN_EMAIL)

      head :forbidden
    end

    def redirect_if_two_factor_enabled
      redirect_to landing_pages_path if current_user.two_factor_enabled?
    end

    def ensure_otp_secret
      return if current_user.otp_secret.present?

      current_user.update!(otp_secret: User.generate_otp_secret)
    end

    def set_provisioning_uri
      @provisioning_uri = current_user.otp_provisioning_uri(current_user.email, issuer: "Urjaas")
    end
  end
end
