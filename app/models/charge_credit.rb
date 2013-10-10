class ChargeCredit
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :cvc, :year, :month, :credit_card_vendor, :terms, :first_name, :last_name,
                :city, :zip_code, :country, :state_name, :billing_address,
                :billing_address_2, :billing_address_3, :masked_number

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end


  def make_payment
    response = ::GATEWAY.purchase PLANS[self.category], User.current.subscription.credit_card_num
    if response.success?
      subscription = User.current.subscription.build self.instance_values
      subscription.save
      true
    else
      self.errors.add :city, "Errors"
      false
    end
  end
end
