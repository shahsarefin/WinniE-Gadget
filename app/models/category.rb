class Category < ApplicationRecord
    # Your existing model code, such as validations and associations
  
    def self.ransackable_attributes(auth_object = nil)
      %w[name description]
    end
  
    # Specify that no associations are allowed to be searched
    def self.ransackable_associations(auth_object = nil)
      []
    end
  end
  