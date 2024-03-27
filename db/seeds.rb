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


# List of Canadian provinces and territories
canadian_provinces = [
  "Alberta", "British Columbia", "Manitoba", "New Brunswick", "Newfoundland and Labrador",
  "Northwest Territories", "Nova Scotia", "Nunavut", "Ontario", "Prince Edward Island",
  "Quebec", "Saskatchewan", "Yukon"
]

canadian_provinces.each do |province_name|
  Province.find_or_create_by(name: province_name)
end

puts "Canadian provinces and territories have been successfully added."

canadian_provinces = [
  { name: 'Alberta', gst_rate: 5, pst_rate: 0, hst_rate: 0 },
  { name: 'British Columbia', gst_rate: 5, pst_rate: 7, hst_rate: 0 },
  { name: 'Manitoba', gst_rate: 5, pst_rate: 7, hst_rate: 0 },
  { name: 'New Brunswick', gst_rate: 0, pst_rate: 0, hst_rate: 15 },
  { name: 'Newfoundland and Labrador', gst_rate: 0, pst_rate: 0, hst_rate: 15 },
  { name: 'Northwest Territories', gst_rate: 5, pst_rate: 0, hst_rate: 0 },
  { name: 'Nova Scotia', gst_rate: 0, pst_rate: 0, hst_rate: 15 },
  { name: 'Nunavut', gst_rate: 5, pst_rate: 0, hst_rate: 0 },
  { name: 'Ontario', gst_rate: 0, pst_rate: 0, hst_rate: 13 },
  { name: 'Prince Edward Island', gst_rate: 0, pst_rate: 0, hst_rate: 15 },
  { name: 'Quebec', gst_rate: 5, pst_rate: 9.975, hst_rate: 0 },
  { name: 'Saskatchewan', gst_rate: 5, pst_rate: 6, hst_rate: 0 },
  { name: 'Yukon', gst_rate: 5, pst_rate: 0, hst_rate: 0 }
]

canadian_provinces.each do |province_data|
  province = Province.find_or_create_by(name: province_data[:name]) do |p|
    p.gst_rate = province_data[:gst_rate]
    p.pst_rate = province_data[:pst_rate]
    p.hst_rate = province_data[:hst_rate]
  end

  if province.persisted?
    puts "Province '#{province.name}' created/updated successfully."
  else
    puts "Failed to create/update province '#{province_data[:name]}'."
    puts "Errors: #{province.errors.full_messages.join(', ')}"
  end
end

puts "Tax rates for Canadian provinces and territories have been successfully added."



