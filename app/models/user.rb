class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:first_name, :ref_code, :referral_code, :time_zone ,
                  :last_name,:is_active,:question_id,:answer,:password_reset ,:referral_code_id , :piece_ids, :sign_up_ip,:zip_code,
                  :subscription_attributes ,:birthday,:gender,:country, :pass_reset_flag,:terms  ,:city,:address1,:address2, :last_instrument_id,:zip_code , :current_sign_in_ip



  attr_accessor :pass_reset_flag, :ref_code
#///// association section//////////
  has_many :user_pieces, :dependent => :destroy
  has_many :pieces ,through: :user_pieces
  belongs_to :referral_code
  belongs_to :question
  has_many :orders
  has_many :user_subscription_logs
  has_one :subscription
#////////// Validations //////////////////#
  validates :question_id,:presence => true
  validates :answer,:presence => true
  validates :first_name ,:presence => true
  validates :last_name ,:presence => true
  validate :check_ref_url, on: :create
  cattr_accessor :current
  accepts_nested_attributes_for :subscription
#//////////////// Scopes ////////////////////#
  scope :user_by_ip , lambda { |user_ip| select("id").find_all_by_sign_up_ip(user_ip)  }

  def valid_referral_code
    if !self.referral_code_id.nil?
      row = ReferralCode.referral_url(self.referral_code_id)
      if row && row.blank?
        errors.add(:referral_code_id, 'invalid referral code')
      end
    end
  end

  after_create :save_user_subscription

  after_save do |resource|
    resource.send_reset_password_instructions if resource.pass_reset_flag
  end

  before_save do  |resource|
    resource.pass_reset_flag = true if  resource.password_reset? && ( resource.changes["password_reset"][1] rescue false   )
  end

  def check_ref_url
    self.referral_code = ReferralCode.referral_url(self.ref_code).first if self.ref_code
    logger.debug "Its ok here"
    errors.add(:ref_code, "Invalid ref code") if self.referral_code.blank? && self.ref_code.present?
    (self.referral_code.present? && self.ref_code.present?) || self.ref_code.blank?
  end

  def save_user_subscription
      Subscription.create! user:  self, sub_type: 0, end_date: DateTime.now + 15.days, is_subscribed: true
  end

  def name
    "#{ self.first_name } #{ self.last_name }"
  end

  def active_for_authentication?
    is_active? && super && !password_reset?
  end

  def inactive_message
    self.password_reset? ? :inactive_user : :inactive
  end

  def send_on_create_confirmation_instructions
    self.skip_confirmation!
    self.save
  end

  def reconfirmation_required?
    false
  end

  def subscription_plan

    if self.subscription
      cat =""
      sub_s= subscription.category
      if sub_s.to_i == 1
        cat= "Student"
      elsif sub_s.to_i == 6
        cat = "Professional"
      else
        cat = "Virtuoso"
      end
      return cat
    end
  end
end
