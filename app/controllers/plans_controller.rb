class PlansController < ApplicationController
  before_filter :check_subscription_validity


  def check_subscription_validity
    if (current_user and current_user.subscription and !(current_user.subscription.credit_card_num.nil?))
      if((current_user.subscription.end_date).to_date < DateTime.now.to_date)
        redirect_to pricing_info_index_path
      end
    else
      if((current_user.created_at+7.days).to_date < DateTime.now.to_date)
        redirect_to pricing_info_index_path
      end
    end
  end
end