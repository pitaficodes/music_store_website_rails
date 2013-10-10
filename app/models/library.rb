class Library < ActiveRecord::Base
  attr_accessible :title
  has_and_belongs_to_many :pieces

  validates_presence_of :title

end
