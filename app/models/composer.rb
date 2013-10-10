class Composer < ActiveRecord::Base
  attr_accessible :first_name,:last_name
  has_many :pieces

  def full_name
    full_name = "#{ self.first_name } #{ self.last_name }"
  end

end
