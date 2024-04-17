class Address < ApplicationRecord
    belongs_to :user
    belongs_to :province
    
    validates :street, :city, :zip_code, presence: true
  end