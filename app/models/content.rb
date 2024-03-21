class Content < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
      %w[page_name title body created_at updated_at content] # Include 'page_name' in the list
    end
  
    def self.ransackable_associations(auth_object = nil)
      [] # Return an array of associations want to allow for searching
    end
  end