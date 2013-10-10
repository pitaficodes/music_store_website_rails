ActiveAdmin.register PianoType do
  menu :parent => "Components Management"

  form do |f|
    f.inputs "Pieces Library" do
      f.input :id
      f.input :title
    end
    f.actions
  end

end
