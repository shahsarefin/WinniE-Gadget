class Product < ApplicationRecord
  has_many :order_items
  has_many_attached :images
  belongs_to :category
  validates :name, :description, :price, :stock_quantity, presence: true

  # Validate content type of images to allow only image files
  validates :images, content_type: { in: %w[image/png image/jpg image/jpeg image/gif],
                                     message: 'is not allowed (only image files are permitted)' },
                     size: { less_than: 5.megabytes,
                             message: 'is too large (should be less than 5MB)' }

  scope :search_by_keyword, -> (keyword) {
    where('LOWER(name) LIKE ?', "%#{keyword.downcase}%")
  }

  scope :filter_by_category, -> (category_id) {
    where(category_id: category_id) if category_id.present?
  }

    # scopes for the requirements 2.4
     # Scope for products on sale
  scope :on_sale, -> { where(on_sale: true) }

  # Scope for new products
  scope :new_products, -> { where('created_at >= ?', 3.days.ago) }

  # Scope for recently updated products
  scope :recently_updated, -> { where('updated_at >= ? AND created_at < ?', 3.days.ago, 3.days.ago) }

  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "description", "id", "id_value", "name", "price", "stock_quantity", "updated_at", "on_sale"]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category]
  end
end
