ActiveAdmin.register Product do

  # Add on_sale to the list of permitted parameters
  permit_params :name, :description, :price, :stock_quantity, :category_id, :on_sale, images: []

  index do
    selectable_column
    id_column
    column :name
    column :price
    column :stock_quantity
    column :category
    column :on_sale # Display on_sale status in the index
    actions
  end

  filter :name
  filter :category
  filter :price
  filter :stock_quantity
  filter :on_sale # Allow filtering by on_sale status

  form html: { enctype: "multipart/form-data" } do |f|
    f.inputs 'Product Details' do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category, as: :select, collection: Category.all.collect { |c| [c.name, c.id] }
      f.input :on_sale # Checkbox for on_sale
      f.input :images, as: :file, input_html: { multiple: true, accept: 'image/*' }
    end
    f.actions
  end

  show do |product|
    attributes_table do
      row :name
      row :description
      row :price
      row :stock_quantity
      row :category
      row :on_sale # Show on_sale status on the product's page

      row :images do
        ul do
          product.images.each do |img|
            li do
              image_tag(img.variant(resize_to_limit: [100, 100]))
            end
          end
        end
      end
    end
    active_admin_comments
  end
end
