require 'faker'
require 'open-uri'

# Categories should already be created as per  array
category_names = ["Monitors", "Laptops", "Smartphones", "Smartwatches", "Tablets"]
categories = category_names.map do |name|
  Category.find_or_create_by!(name: name)
end

# Destroy previous products to avoid duplication on re-seed
Product.destroy_all

# Pre-defined Unsplash image URLs for each category (these should be free to use and in compliance with Unsplash terms)
unsplash_image_urls = {
  "Monitors" => "https://source.unsplash.com/featured/?monitor",
  "Laptops" => "https://source.unsplash.com/featured/?laptop",
  "Smartphones" => "https://source.unsplash.com/featured/?smartphone",
  "Smartwatches" => "https://source.unsplash.com/featured/?smartwatch",
  "Tablets" => "https://source.unsplash.com/featured/?tablet"
}

# Seed 100 products
100.times do
  category = categories.sample
  name = Faker::Device.model_name
  description = Faker::Lorem.sentence(word_count: 10)
  price = Faker::Commerce.price(range: 300..1000)
  stock_quantity = Faker::Number.between(from: 10, to: 100)

  product = Product.new(
    name: name,
    description: description,
    price: price,
    stock_quantity: stock_quantity,
    category: category
  )

  # Fetch an image from Unsplash and attach it to the product
  image_url = unsplash_image_urls[category.name]
  downloaded_image = URI.open(image_url)

  product.images.attach(io: downloaded_image, filename: "m-#{name.downcase.split.join('-')}.jpg")

  product.save!
end

puts "Products have been successfully seeded."



