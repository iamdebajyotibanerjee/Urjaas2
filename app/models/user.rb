# app/models/user.rb
class User < ApplicationRecord
  devise :two_factor_authenticatable, :timeoutable, :validatable

  ADMIN_EMAIL = if Rails.env.production?
    ENV.fetch("ADMIN_EMAIL").strip.downcase.freeze
  else
    ENV.fetch("ADMIN_EMAIL", "ks.brandbuilder@gmail.com").strip.downcase.freeze
  end

  def active_for_authentication?
    super && email.downcase == ADMIN_EMAIL.downcase
  end

  def two_factor_enabled?
    otp_required_for_login? && otp_secret.present?
  end

  # Uses Devise's built-in translation key
  def inactive_message
    :invalid
  end
end
