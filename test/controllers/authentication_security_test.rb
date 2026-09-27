require "test_helper"

class AuthenticationSecurityTest < ActionDispatch::IntegrationTest
  self.fixture_table_names = []
  include Devise::Test::IntegrationHelpers

  setup do
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
    Rack::Attack.cache.store.clear
  end

  test "signs out an administrator after five minutes without activity" do
    user = User.create!(email: User::ADMIN_EMAIL, password: "strong-password-123")
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
end
