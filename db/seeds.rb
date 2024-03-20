require 'faker'

if Rails.env.development?
    admin_email = 'admin@example.com'
    unless AdminUser.exists?(email: admin_email)
      AdminUser.create!(email: admin_email, password: 'password', password_confirmation: 'password')
      puts 'AdminUser has been created'
    else
      puts 'AdminUser already exists'
    end
  end
  
  categories = Category.all

  
  Product.destroy_all
  
 
  monitors = ["LG Ultrawide Monitor", "Dell 27-inch 4K Monitor", "Asus ROG Swift Gaming Monitor", "Samsung Curved Monitor"]
  laptops = ["Apple MacBook Pro", "Lenovo ThinkPad X1 Carbon", "Dell XPS 13", "HP Spectre x360"]
  smartphones = ["iPhone 13 Pro", "Samsung Galaxy S21 Ultra", "Google Pixel 6 Pro", "OnePlus 9 Pro"]
  smartwatches = ["Apple Watch Series 7", "Samsung Galaxy Watch 4", "Fitbit Versa 3", "Garmin Fenix 6"]
  tablets = ["iPad Pro", "Samsung Galaxy Tab S7+", "Microsoft Surface Pro 8", "Lenovo Tab P11"]
  
  
  # Create specific products for each category
  categories.each do |category|
    products = case category.name
               when "Monitors"
                 monitors
               when "Laptops"
                 laptops
               when "Smartphones"
                 smartphones
               when "Smartwatches"
                 smartwatches
               when "Tablets"
                 tablets
               else
                 []
               end
  
    # Create specific products for the category
    products.each do |product_name|
      Product.create!(
        name: product_name,
        description: Faker::Lorem.paragraph(sentence_count: 4),
        price: Faker::Commerce.price(range: 50..1000.0, as_string: true),
        category: category,
        stock_quantity: Faker::Number.between(from: 0, to: 100)
      )
    end
  
    # Generate additional random products
    (150 - products.length).times do
      Product.create!(
        name: Faker::Device.model_name,
        description: Faker::Lorem.paragraph(sentence_count: 4),
        price: Faker::Commerce.price(range: 50..1000.0, as_string: true),
        category: category,
        stock_quantity: Faker::Number.between(from: 0, to: 100)
      )
    end
  end
  
  puts "Gadget products created successfully!"
  