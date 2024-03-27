# app/models/order.rb
class Order < ApplicationRecord
  has_many :order_items
  belongs_to :customer
  belongs_to :user
  has_one :address
  accepts_nested_attributes_for :address

  def calculate_total_with_taxes
    subtotal = order_items.sum(&:total_price)
    taxes = user.address.province.calculate_taxes(subtotal)
    subtotal + taxes
  end
end
