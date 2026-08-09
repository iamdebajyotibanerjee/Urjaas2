# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable

  ADMIN_EMAIL = "ks.brandbuilder@gmail.com"

  def active_for_authentication?
    super && email.downcase == ADMIN_EMAIL.downcase
  end

  # Uses Devise's built-in translation key
  def inactive_message
    :invalid
  end
end
