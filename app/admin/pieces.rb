ActiveAdmin.register Piece do

  menu :parent => "Piece Management"

  form partial: "piece_audio_files_fileds"

  filter :id
  filter :title
  filter :composer
  filter :tempo
  filter :piano_type
  filter :key
  filter :created_at
  filter :updated_at
  filter :is_active

  index do
    selectable_column
    column :id
    column :title
    column :created_at
    column :updated_at
    default_actions
  end

  show do
    render "show_piece"
  end

end
