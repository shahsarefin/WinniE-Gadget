# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Ensuring an AdminUser is created for development environment
if Rails.env.development?
    admin_email = 'admin@example.com'
    unless AdminUser.exists?(email: admin_email)
      AdminUser.create!(email: admin_email, password: 'password', password_confirmation: 'password')
      puts 'AdminUser has been created'
    else
      puts 'AdminUser already exists'
    end
  end
  
  # Adding real category names
  categories = ["Laptops", "Smartphones", "Smartwatches", "Headphones", "Monitors"]
  
  categories.each do |category_name|
    Category.find_or_create_by!(name: category_name)
  end
  
  puts "Categories created successfully!"
  
