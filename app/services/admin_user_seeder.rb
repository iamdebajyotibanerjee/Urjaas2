class AdminUserSeeder
  class << self
    def call!
      if User.exists?
        return puts("Admin user already exists; leaving credentials unchanged.") if User.exists?(email: User::ADMIN_EMAIL)

        raise "Users already exist, but the configured ADMIN_EMAIL is not present; refusing to seed another admin."
      end

      configured_email = ENV.fetch("ADMIN_EMAIL") { raise "ADMIN_EMAIL must be configured for the initial admin seed." }
      unless configured_email.strip.casecmp?(User::ADMIN_EMAIL)
        raise "ADMIN_EMAIL must match the configured admin account email."
      end

      admin_password = ENV.fetch("ADMIN_PASSWORD") { raise "ADMIN_PASSWORD must be configured for the initial admin seed." }
      raise "ADMIN_PASSWORD must be at least 16 characters." if admin_password.length < 16

      User.create!(email: User::ADMIN_EMAIL, password: admin_password)
      puts "Initial admin account created. Two-factor enrollment is required at first sign-in."
    end
  end
end
