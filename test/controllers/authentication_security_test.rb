require "test_helper"

class AuthenticationSecurityTest < ActionDispatch::IntegrationTest
  self.fixture_table_names = []
  include Devise::Test::IntegrationHelpers

  setup do
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
    Rack::Attack.cache.store.clear
  end

  test "signs out an administrator after five minutes without activity" do
    user = create_two_factor_admin
    sign_in user

    get landing_pages_path
    assert_response :success

    travel 6.minutes do
      get landing_pages_path
      get landing_pages_path if response.redirect?
    end

    assert_redirected_to new_user_session_path
  end

  test "throttles repeated login attempts for the same email and IP" do
    5.times do
      post user_session_path, params: { user: { email: "admin@example.test", password: "wrong-password" } }
      assert_response :unprocessable_content
    end

    post user_session_path, params: { user: { email: "admin@example.test", password: "wrong-password" } }

    assert_response :too_many_requests
  end

  test "requires a valid authenticator code after two-factor enrollment" do
    user = create_two_factor_admin
    code = user.current_otp

    post user_session_path, params: { user: { email: user.email, password: "strong-password-123" } }
    assert_response :unprocessable_content

    post user_session_path, params: { user: { email: user.email, password: "strong-password-123", otp_attempt: "000000" } }
    assert_response :unprocessable_content

    post user_session_path, params: { user: { email: user.email, password: "strong-password-123", otp_attempt: code } }
    assert_redirected_to landing_pages_path

    delete destroy_user_session_path
    post user_session_path, params: { user: { email: user.email, password: "strong-password-123", otp_attempt: code } }
    assert_response :unprocessable_content
  end

  test "forces an unenrolled admin to set up two-factor before using the dashboard" do
    user = User.create!(email: User::ADMIN_EMAIL, password: "strong-password-123")
    sign_in user

    get landing_pages_path
    assert_redirected_to admin_two_factor_setup_path

    get admin_two_factor_setup_path
    assert_response :success
    user.reload
    assert user.otp_secret.present?

    post admin_two_factor_setup_path, params: { two_factor_setup: { otp_attempt: user.current_otp } }
    assert_redirected_to landing_pages_path
    assert user.reload.two_factor_enabled?
  end

  private

  def create_two_factor_admin
    User.create!(
      email: User::ADMIN_EMAIL,
      password: "strong-password-123",
      otp_secret: User.generate_otp_secret,
      otp_required_for_login: true
    )
  end
end
