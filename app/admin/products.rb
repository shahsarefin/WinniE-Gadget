ActiveAdmin.register Product do
  
  permit_params :name, :description, :price, :stock_quantity, :category_id, images: []

  index do
    id_column
    column :name
    column :price
    column :stock_quantity
    column :category
    actions
  end

  filter :name
  filter :category

  form do |f|
    f.inputs 'Product Details' do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category, as: :select, collection: Category.all
      
      f.input :images, as: :file, input_html: { multiple: true }
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
