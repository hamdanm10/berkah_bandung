# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.find_or_initialize_by(username: 'super_admin')

if user.new_record?
  user.full_name = 'Super Admin'
  user.password = 'asdfasdf'
  user.password_confirmation = 'asdfasdf'
  user.role = 'super_admin'
  user.is_active = true
  user.save!

  puts "User 'super_admin' has been successfully created"
else
  puts "User 'super_admin' already exists, skipping"
end

puts 'App settings has been successfully created' if AppSetting.first_or_create!(last_stock_check: Time.current)
