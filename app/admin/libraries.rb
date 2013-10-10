ActiveAdmin.register Library , as: "Genres"  do
  menu :parent => "Components Management"
  #menu :label => "Genres"

  index do
    column :title
    column :created_at
    column :updated_at
    default_actions
  end

  filter :title

  form do |f|
    f.inputs "Pieces Library" do
      f.input :title
    end
    f.actions
  end

end
