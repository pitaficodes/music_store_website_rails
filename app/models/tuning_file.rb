class TuningFile < ActiveRecord::Base

  mount_uploader :file , TuningFileUploader

  belongs_to :tuning
  belongs_to :instrument
  attr_accessible :file, :str_key, :tuning_id ,:instrument_id
end
