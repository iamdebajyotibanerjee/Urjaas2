module Admin
  class PasswordsController < BaseController
    def edit
      response.headers["Cache-Control"] = "no-store"
    end

    def update
      response.headers["Cache-Control"] = "no-store"
      attributes = password_params

      if attributes[:password].to_s.length < 16
        current_user.errors.add(:password, "must be at least 16 characters")
        render :edit, status: :unprocessable_content
      elsif current_user.update_with_password(attributes)
        redirect_to landing_pages_path, notice: "Your password has been changed."
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def password_params
      params.require(:user).permit(:current_password, :password, :password_confirmation)
    end
  end
end
