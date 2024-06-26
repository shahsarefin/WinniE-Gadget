class User < ApplicationRecord
  has_many :orders
  has_many :order_items, through: :orders
  has_one :address

  #for Address model
  has_one :address
  accepts_nested_attributes_for :address

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
end

