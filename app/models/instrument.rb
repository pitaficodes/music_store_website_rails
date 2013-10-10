class Instrument < ActiveRecord::Base
  attr_accessible :title , :tuning_files_attributes
  has_and_belongs_to_many :pieces
  has_many :tuning_files
  accepts_nested_attributes_for :tuning_files, :allow_destroy => true, :reject_if => lambda { |a| a['str_key'].blank? }
  def to_s
    title
  end
end
