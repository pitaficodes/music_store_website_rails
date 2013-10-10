class Key < ActiveRecord::Base
  attr_accessible :title
  has_many :audio_files

  validates_uniqueness_of :title
end
