ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :category_id, :image
  
  index do
    selectable_column
    id_column
    column :name
    column :price
    column :stock_quantity
    column :category
    column 'Image' do |product|
      if product.image.attached?
        image_tag product.image.variant(resize_to_limit: [100, 100])
      end
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :stock_quantity
      row :category
      row :image do |product|
        if product.image.attached?
          image_tag product.image
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Product Details' do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category, as: :select, collection: Category.all
      f.input :image, as: :file, hint: f.object.image.attached? ? image_tag(f.object.image.variant(resize_to_limit: [200, 200])) : ''
    end
    f.actions
  end

  filter :name
  filter :price
  filter :stock_quantity
  filter :category, as: :select

  # Permit parameters for Active Storage
  controller do
    def permitted_params
      params.permit!
    end
  end
end
