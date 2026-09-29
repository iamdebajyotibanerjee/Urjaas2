require "test_helper"

module Admin
  class PasswordsControllerTest < ActionDispatch::IntegrationTest
    self.fixture_table_names = []
    include Devise::Test::IntegrationHelpers

    test "requires an authenticated admin and two-factor enrollment" do
      get edit_admin_password_path
      assert_redirected_to new_user_session_path

      admin = User.create!(email: User::ADMIN_EMAIL, password: "initial-password-123", otp_secret: User.generate_otp_secret)
      sign_in admin

      get edit_admin_password_path
      assert_redirected_to admin_two_factor_setup_path
    end

    test "changes the password only with the correct current password" do
      admin = enrolled_admin
      sign_in admin

      patch admin_password_path, params: { user: {
        current_password: "wrong-current-password",
        password: "a-new-unique-password-456",
        password_confirmation: "a-new-unique-password-456"
      } }

      assert_response :unprocessable_content
      assert admin.reload.valid_password?("initial-password-123")

      patch admin_password_path, params: { user: {
        current_password: "initial-password-123",
        password: "a-new-unique-password-456",
        password_confirmation: "a-new-unique-password-456"
      } }

      assert_redirected_to landing_pages_path
      assert admin.reload.valid_password?("a-new-unique-password-456")
      assert_not admin.valid_password?("initial-password-123")
      assert admin.two_factor_enabled?
    end

    test "rejects short passwords and mismatched confirmation" do
      admin = enrolled_admin
      sign_in admin

      patch admin_password_path, params: { user: {
        current_password: "initial-password-123",
        password: "short",
        password_confirmation: "short"
      } }

      assert_response :unprocessable_content
      assert admin.reload.valid_password?("initial-password-123")
    end

    private

    def enrolled_admin
      User.create!(
        email: User::ADMIN_EMAIL,
        password: "initial-password-123",
        otp_secret: User.generate_otp_secret,
        otp_required_for_login: true
      )
    end
  end
end
