class Order < ActiveRecord::Base
  attr_accessible :billing_address, :billing_address2, :city, :date, :state, :transaction_token, :zip
  belongs_to :coupon_code
  belongs_to :pieces
  belongs_to :user
  has_many :pieces ,through: :orders_pieces

end
