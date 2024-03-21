class Category < ApplicationRecord
  has_many :products

  # Explicitly specifying searchable attributes for Ransack
  def self.ransackable_attributes(auth_object = nil)
    # Directly listing the attributes to be searchable
    ['name', 'description'] # Add 'description' or any other attributes  
  end

  # Explicitly specifying which associations can be searched through with Ransack
  def self.ransackable_associations(auth_object = nil)
    # Directly listing the associations want to include for searching
    ['products'] # or [] if there are no associations want to make searchable
  end
end
