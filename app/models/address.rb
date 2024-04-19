class Address < ApplicationRecord
    belongs_to :user
    belongs_to :province
    
    validates :street, :city, presence: true
  end