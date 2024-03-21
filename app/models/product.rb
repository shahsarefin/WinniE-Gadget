class Product < ApplicationRecord
  has_many_attached :images
  belongs_to :category
  validates :name, :description, :price, :stock_quantity, presence: true

  scope :search_by_keyword, -> (keyword) {
    where("name LIKE :keyword OR description LIKE :keyword", keyword: "%#{keyword}%")
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[id name description price stock_quantity category_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category]
  end
end
