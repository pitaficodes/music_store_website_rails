ActiveAdmin.register Question do
  actions :all, :except => [:destroy]
  index do
    column :question
    default_actions

  end
  filter :question

  form do |f|
    f.inputs "Questions " do
      f.input :question

    end
    f.actions
  end
end
