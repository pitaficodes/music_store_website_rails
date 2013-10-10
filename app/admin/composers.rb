ActiveAdmin.register Composer do
  menu :parent => "Components Management"
  index do
    column :first_name
    column :last_name
    column :created_at
    column :updated_at
    default_actions
  end
  form do |f|
    f.inputs "composers" do
      f.input :first_name
      f.input :last_name
    end
    f.actions
  end
end
