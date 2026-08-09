# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin_email = "ks.brandbuilder@gmail.com"
admin_password = "4321@ccpS??"

# Remove all other accounts from the database
User.where.not(email: admin_email).destroy_all

# Find or create the single admin user
admin_user = User.find_or_initialize_by(email: admin_email)
admin_user.assign_attributes(
  password: admin_password,
  password_confirmation: admin_password
)

if admin_user.save
  puts "----------------------------------------"
  puts "Single Admin account active:"
  puts "Email:    #{admin_email}"
  puts "Password: #{admin_password}"
  puts "----------------------------------------"
else
  puts "Failed to seed admin user:"
  puts admin_user.errors.full_messages.join(", ")
end
