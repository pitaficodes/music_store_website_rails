namespace :subscription do

  task :check_subscription => :environment  do
    Subscription.all.each do |sub|
      SubscriptionMailer.send_subscription_end_notification(sub.user , sub).deliver if DateTime.now.to_date == sub.end_date.to_date - 7.days
    end
  end

  task :renew_subscription => :environment do
    Subscription.all.each do |sub|
      if DateTime.now.to_date > sub.end_date.to_date && sub.is_renewable?
        unless sub.renew_subscription
          sub.update_attributes credit_card_num: "" , is_subscribed: false
          SubscriptionMailer.credit_card_did_process(sub.user).deliver
        end
      end
    end
  end

  task :check_free_subscription => :environment  do
    Subscription.all.each do |sub|
      SubscriptionMailer.send_free_subscription_notification(sub.user , sub).deliver if DateTime.now.to_date == sub.end_date.to_date - 7.days && sub.sub_type == 0
    end
  end

  task :check_credit_card_expiration => :environment  do
    Subscription.all.each do |sub|
      SubscriptionMailer.check_credit_card_expiration(sub.user , sub).deliver if DateTime.now.to_date == sub.card_expiry_date - 7.days
    end
  end


end