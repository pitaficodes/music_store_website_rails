class UserSubscriptionLog < ActiveRecord::Base
  attr_accessible :amount, :sub_end_date, :sub_type, :user

  belongs_to :user

end
