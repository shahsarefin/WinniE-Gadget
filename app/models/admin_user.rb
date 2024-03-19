class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable
  
    # Define the ransackable attributes
    def self.ransackable_attributes(auth_object = nil)
      %w[id email created_at updated_at]
    end
  
    # ransackable_associations 
    def self.ransackable_associations(auth_object = nil)
      []
    end
end
