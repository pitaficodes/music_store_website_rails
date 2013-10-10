class SiteStyleSetting < ActiveRecord::Base
  attr_accessible :button_bg_color, :button_text_color, :button_text_font, :text_color, :text_font, :is_active
end
