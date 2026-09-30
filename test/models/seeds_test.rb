require "test_helper"

class SeedsTest < ActiveSupport::TestCase
  self.fixture_table_names = []

  test "creates the initial admin from the environment and never resets existing credentials" do
    original_password = ENV["ADMIN_PASSWORD"]
    original_email = ENV["ADMIN_EMAIL"]
    ENV["ADMIN_PASSWORD"] = "first-bootstrap-password-123"
    ENV["ADMIN_EMAIL"] = User::ADMIN_EMAIL
    User.delete_all

    AdminUserSeeder.call!
    admin = User.find_by!(email: User::ADMIN_EMAIL)
    encrypted_password = admin.encrypted_password

    ENV["ADMIN_PASSWORD"] = "a-different-password-456"
    AdminUserSeeder.call!

    assert_equal encrypted_password, admin.reload.encrypted_password
    assert_not admin.two_factor_enabled?
  ensure
    ENV["ADMIN_PASSWORD"] = original_password
    ENV["ADMIN_EMAIL"] = original_email
  end

  test "does not seed without both credentials" do
    original_password = ENV.delete("ADMIN_PASSWORD")
    original_email = ENV.delete("ADMIN_EMAIL")
    User.delete_all

    assert_raises(RuntimeError) { AdminUserSeeder.call! }
    assert_empty User.all
  ensure
    ENV["ADMIN_PASSWORD"] = original_password
    ENV["ADMIN_EMAIL"] = original_email
  end
end
