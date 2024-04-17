class Content < ApplicationRecord

  validates :page_name, :title, :body, presence: true
  
    def self.ransackable_attributes(auth_object = nil)
      %w[page_name title body created_at updated_at content] 
    end
  
    def self.ransackable_associations(auth_object = nil)
      [] 
    end
  end