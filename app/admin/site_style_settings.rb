#ActiveAdmin.register SiteStyleSetting do
#  actions :all, :except => [:new]
#  config.filters = false
#  index do
#    column :text_color
#    column :text_font
#    column :is_active
#    default_actions
#  end
#
#  form do |f|
#    f.inputs "Details" do
#      f.input :button_bg_color, :input_html => { :class => 'color'}
#      f.input :button_text_color, :input_html => { :class => 'color'}
#      f.input :button_text_font
#      f.input :text_color, :input_html => { :class => 'color'}
#      f.input :text_font
#
#
#    end
#    f.actions
#  end
#
#end
