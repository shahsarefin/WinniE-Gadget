ActiveAdmin.register Category do
    permit_params :name
  
    index do
      selectable_column
      id_column
      column :name
      actions
    end
  
    form do |f|
      f.inputs do
        f.input :name
      end
      f.actions
    end
  
    show do |category|
      attributes_table do
        row :id
        row :name
        # Add other fields as needed
      end
      active_admin_comments
    end


  end
  