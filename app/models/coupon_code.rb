class CouponCode < ActiveRecord::Base
  attr_accessible :code, :discount_percentage, :name
  has_many :orders
end
