class Question < ActiveRecord::Base
  attr_accessible :question
  has_many :user
  validates :question,:presence=> true

end
