class Subscription < ActiveRecord::Base
  belongs_to :user
  attr_accessible :end_date, :sub_type , :user , :first_name , :last_name , :credit_card_num,:card_expiry_date, :is_subscribed , :billing_address , :billing_address_2 , :credit_card_vendor,:terms,:category,:cvc,:city,:state_name,:country,:zip_code,:billing_name,:masked_number , :is_renewable , :start_date
  ################# Create New Subscription ################
  def self.purchase params
    raise "Invalid::Plan" unless [1, 6, 12].include? params[:user_infos][:category].to_i
    p = params[:user_infos][:category]; params.delete :plan
    user_infos = params[:user_infos]; params.delete :user_infos
    par = params
    credit_card = ActiveMerchant::Billing::CreditCard.new params
    vault_id = ::STORE.store credit_card
    valut_number = vault_id.params["braintree_customer"]["id"] if vault_id.params["braintree_customer"]
    7.times { |i| puts "******#{ vault_id.inspect if i == 4 }******"  }
    if valut_number
      masked_id= vault_id.params["braintree_customer"]["credit_cards"][0]["masked_number"]
      credit_card = ActiveMerchant::Billing::CreditCard.new params
      response = ::GATEWAY.purchase PLANS[p], valut_number
      if response.success?
        User.current.subscription.delete  if User.current.subscription
        s = Subscription.new user: User.current, sub_type: p,card_expiry_date:DateTime.new(par[:year].to_i,par[:month].to_i,1).to_date, end_date: (DateTime.now + p.to_i.months).to_date , credit_card_num: valut_number , is_subscribed: true , billing_address: user_infos[:billing_address] , billing_address_2: user_infos[:billing_address_2]+" "+user_infos[:billing_address_3],credit_card_vendor: par[:brand], terms:user_infos[:terms],category:user_infos[:category],cvc:par[:verification_value],billing_name:par[:first_name]+" "+par[:last_name],first_name: par[:first_name] , last_name: par[:last_name] ,city:user_infos[:city],zip_code:user_infos[:zip_code],country:user_infos[:country],state_name:user_infos[:state_name], masked_number: masked_id , start_date: DateTime.now
        log = UserSubscriptionLog.new user: User.current , sub_type: p , amount: PLANS[p] , sub_end_date: (DateTime.now + p.to_i.months).to_date
        log.save
        s.save
        true
      else
        response
      end
    else
      vault_id
    end
  end
  ################# Renew Subscription ################
  def renew_subscription
    card =  { number: self.credit_card_num , first_name: self.user.first_name , last_name: self.user.last_name , year: DateTime.now.year , month: DateTime.now.month , brand: self.credit_card_vendor }
    credit_card = ActiveMerchant::Billing::CreditCard.new card
    response = ::GATEWAY.purchase PLANS[self.sub_type.to_s], self.credit_card_num
    if response.success?
      self.update_attributes is_subscribed: true , end_date: (DateTime.now + self.sub_type.months).to_date
      log = UserSubscriptionLog.new user: self.user, sub_type: self.sub_type , amount: PLANS[self.sub_type.to_s] , sub_end_date: (DateTime.now + self.sub_type.months).to_date
      log.save!
      SubscriptionMailer.send_subscription_renew_notification(self.user , self).deliver
    else
      false
    end
  end
  ################# Update Subscription ################
  def update_subscription
    card =  { number: self.credit_card_num , first_name: self.user.first_name , last_name: self.user.last_name , year: DateTime.now.year , month: DateTime.now.month , brand: self.credit_card_vendor }
    credit_card = ActiveMerchant::Billing::CreditCard.new card
    response = ::GATEWAY.purchase PLANS[self.sub_type.to_s], self.credit_card_num
    if response.success?
      self.update_attributes is_subscribed: true , end_date: (DateTime.now + self.sub_type.months).to_date
      log = UserSubscriptionLog.new user: self.user, sub_type: self.sub_type , amount: PLANS[self.sub_type.to_s] , sub_end_date: (DateTime.now + self.sub_type.months).to_date
      log.save!

    else
      false
    end
  end
  def sub_category(user_id)
    subscription = User.find_by_id(user_id).subscription
    if subscription
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
  ##################### Update Billing Information ################
  def update_billing_credit_card params
    card = params[:subscription][:card].merge first_name: params[:first_name] , last_name: params[:last_name] , month: params[:month] , year: params[:year]
    credit_card = ActiveMerchant::Billing::CreditCard.new card
    vault_id = ::STORE.store credit_card
    valut_number = vault_id.params["braintree_customer"]["id"] if vault_id.params["braintree_customer"]
    if valut_number
      self.update_attributes credit_card_num: valut_number , masked_number: vault_id.params["braintree_customer"]["credit_cards"][0]["masked_number"]
      true
    else
      vault_id
    end
  end

end
