class SubscriptionsController < ApplicationController
  authorize_resource class: false
  def new
    redirect_to edit_user_registration_path , notice: "Already Subscribed" if current_user.subscription.try(:is_subscribed?) && current_user.subscription.try(:sub_type) != 0
  end
  def create
    transaction = Subscription.purchase params[:subscription]
    if transaction == true
      SubscriptionMailer.send_subscription_new_notification(current_user).deliver
      redirect_to subscription_details_subscriptions_path
    else
      redirect_to new_subscription_path(message: transaction.message)
    end
  end
  def edit
    @subscription = current_user.subscription
  end
  def update
    @subscription = current_user.subscription
    valut = @subscription.update_billing_credit_card params unless params[:subscription][:card][:number].blank?
    params[:subscription].delete(:card).merge(billing_name: "#{params[:first_name]}-#{params[:last_name]}")
    if valut == true || params[:subscription][:card].blank?
        @subscription.update_attributes params[:subscription]
        flash[:notice] = "You have successfully updated your billing information."
        UserMailer.billing_information(@subscription,current_user).deliver
        redirect_to edit_user_registration_path
    else
      redirect_to edit_subscription_path(message: valut.message)
    end
  end
  def subscription_details
    @subscription =  current_user.subscription if current_user.subscription
  end

  def cancel_subscription
    if current_user.subscription.update_attributes is_renewable: (params[:renew] == "true" ? true : false)
      flash[:notice] = "You have disabled the auto renewal of you subscription." if params[:renew] == "false"
      flash[:notice] = "You have enabled the auto renewal of you subscription." if params[:renew] == "true"
      render js: "window.location='#{edit_user_registration_path}'"
    end
  end

end