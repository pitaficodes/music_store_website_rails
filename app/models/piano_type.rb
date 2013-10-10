class PianoType < ActiveRecord::Base
  attr_accessible :title , :id
  has_many :audio_files
end
