require "digest"

class Rack::Attack
  cache.store = Rails.cache

  throttle("devise/sign_in/ip", limit: 20, period: 15.minutes) do |request|
    request.ip if request.post? && request.path == "/users/sign_in"
  end

  throttle("devise/sign_in/email", limit: 10, period: 15.minutes) do |request|
    next unless request.post? && request.path == "/users/sign_in"

    email = request.params.dig("user", "email").to_s.downcase.strip
    next if email.blank?

    Digest::SHA256.hexdigest(email)
  end

  throttle("devise/sign_in/email_and_ip", limit: 5, period: 15.minutes) do |request|
    next unless request.post? && request.path == "/users/sign_in"

    email = request.params.dig("user", "email").to_s.downcase.strip
    next if email.blank?

    Digest::SHA256.hexdigest([ email, request.ip ].join(":"))
  end

  throttle("devise/two_factor_setup/ip", limit: 10, period: 15.minutes) do |request|
    request.ip if request.post? && request.path == "/admin/two_factor_setup"
  end
end
