ActiveAdmin.register Key do
  actions :all, except: [:new,:destroy, :edit]

  menu :parent => "Components Management"
  index do
    selectable_column
    column :title
    column :created_at
    column :updated_at
    default_actions
  end

  filter :title

  form do |f|
    f.inputs "Pieces Key" do
      f.input :title
    end
    f.actions
  end

end
