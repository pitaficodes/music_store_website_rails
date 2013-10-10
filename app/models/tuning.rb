class Tuning < ActiveRecord::Base
  attr_accessible :tuning
  has_many :audio_files
  has_many :tuning_files

  validates_format_of :tuning , :with => /[0-9]/
end
