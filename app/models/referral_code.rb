class ReferralCode < ActiveRecord::Base
  attr_accessible :code, :company_name, :logo , :company_url, :is_active
  mount_uploader :logo , LogoUploader
  has_many :users
  validates  :code, :uniqueness => true
  before_save { |referral_code| referral_code.code = referral_code.code.downcase }
  scope :referral_url , lambda { |ref_code| where("code = ? AND is_active = ?", ref_code.try(:downcase) , true)  }
end
