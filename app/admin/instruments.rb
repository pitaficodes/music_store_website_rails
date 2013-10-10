ActiveAdmin.register Instrument do
  menu :parent => "Components Management"
  form partial: "instrument_tuning_files_fildes"
  index do
    column :title
    column :created_at
    column :updated_at
    default_actions
  end

  show do
    render "show_instrument"
  end

end
