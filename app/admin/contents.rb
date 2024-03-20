ActiveAdmin.register Content do

  permit_params :page_name, :content

  form do |f|
    f.inputs do
      f.input :page_name, as: :select, collection: ['contact', 'about']
      f.input :content, as: :text
    end
    f.actions
  end
  
  show do
    attributes_table do
      row :page_name
      row :content
    end
  end
  
end
