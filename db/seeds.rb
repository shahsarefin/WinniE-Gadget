require 'faker'


category_names = ["Monitors", "Laptops", "Smartphones", "Smartwatches", "Tablets"]
categories = category_names.map do |name|
  Category.find_or_create_by!(name: name)
end



# Clear out existing products
Product.destroy_all

# Assuming categories already exist based on your instructions
categories = Category.all.index_by(&:name)

# Define new products based on your specifications
new_products = [
  # Monitors
  { name: "LG Ultrawide Monitor", category: "Monitors" },
  { name: "Samsung Curved Monitor", category: "Monitors" },
  { name: "Lenovo Gaming Monitor", category: "Monitors" },
  { name: "LG 4K UHD Monitor", category: "Monitors" },
  
  # Laptops
  { name: "MacBook Pro", category: "Laptops" },
  { name: "MacBook Air", category: "Laptops" },
  { name: "Dell XPS", category: "Laptops" },
  { name: "Asus ZenBook", category: "Laptops" },
  
  # Smartphones
  { name: "iPhone 13 Pro", category: "Smartphones" },
  { name: "Samsung Galaxy S21", category: "Smartphones" },
  { name: "Google Pixel 6", category: "Smartphones" },
  { name: "OnePlus 9", category: "Smartphones" },
  
  # Smartwatches
  { name: "Samsung Galaxy Watch", category: "Smartwatches" },
  { name: "Apple Watch Series 7", category: "Smartwatches" },
  
  # Tablets
  { name: "Samsung Galaxy Tab S7", category: "Tablets" },
  { name: "iPad Pro", category: "Tablets" },
]

# Create new products
new_products.each do |product_info|
  Product.create!(
    name: product_info[:name],
    description: "Description for #{product_info[:name]}, a high-quality product.",
    price: rand(300..1000), 
    stock_quantity: rand(10..100), 
    category: categories[product_info[:category]]
  )
end

puts "Products have been successfully added."

