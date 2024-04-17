class Category < ApplicationRecord
  has_many :products

  validates :name, presence: true

  
  def self.ransackable_attributes(auth_object = nil)
    
    ['name', 'description']  
  end

  
  def self.ransackable_associations(auth_object = nil)
    
    ['products'] 
  end
end
