ActiveAdmin.register User do
  actions :all , :except => [:new]
  index do
    selectable_column
    column :first_name
    column :last_name
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :is_active
    default_actions
  end

  filter :email
  filter :first_name
  filter :last_name

  show do |ad|
    attributes_table do
      row :id
      row :email
      row :first_name
      row :last_name
      row :birthday
      row :gender
      row :address1
      row :address2
      row :city
      row :state_name
      row :zip_code
      row :country
      row :question_id do |q|
        if !q.question.blank?
          q.question.question
        end
      end
      row :answer
      row :referral_code_id do |r|
        if !r.referral_code.blank?
          r.referral_code.code
        end
      end

      if !ad.subscription.blank?
        row " " do
          h3 "Subscription Details"
        end
        row "Subscription Type" do |s|
          if s.subscription.sub_type.to_i == 0
            "Free"
          elsif s.subscription.sub_type.to_i == 1
            "Student"
          elsif s.subscription.sub_type.to_i == 6
            "Professional"
          elsif s.subscription.sub_type.to_i == 12
            "Virtuoso"
          end
        end
        row :is_subscribed do |s|
          s.subscription.is_subscribed
        end
        row "Subscription End Date" do |s|
          s.subscription.end_date
        end
        row :category do |s|
          s.subscription.category
        end
        row :credit_card_number do |s|
          s.subscription.credit_card_num
        end
        row :credit_card_vendor do |s|
          s.subscription.credit_card_vendor
        end
        row :cvc do |s|
          s.subscription.cvc
        end
        row :credit_card_expiry_date do |s|
          s.subscription.card_expiry_date
        end
        row :billing_name do |s|
          s.subscription.billing_name
        end
        row :billing_address do |s|
          s.subscription.billing_address
        end
        row :billing_address_2 do |s|
          s.subscription.billing_address_2
        end
        row :billing_city do |s|
          s.subscription.city
        end
        row :billing_state_name do |s|
          s.subscription.state_name
        end
        row :billing_zip_code do |s|
          s.subscription.zip_code
        end
        row :billing_country do |s|
          s.subscription.country
        end
      end


      if !ad.user_subscription_logs.blank?
        row " " do
          h3 "Subscription Log Details"
        end

        i=0
        ad.user_subscription_logs.each do |usl|
          i= i+1
          row " " do ||
            b "User Subscription Log #{i}"
          end
          row :subscription_type do |st|
            if usl.sub_type.to_i == 0
              "Free"
            elsif usl.sub_type.to_i == 1
              "Student"
            elsif usl.sub_type.to_i == 6
              "Professional"
            elsif usl.sub_type.to_i == 12
              "Virtuoso"
            end
          end
          row :amount do |a|
            usl.amount
          end
          row :subscription_end_date do |sed|
            usl.sub_end_date
          end
          row :subscription_created_at do |sed|
            usl.created_at
          end
          row :subscription_updated_at do |sed|
            usl.updated_at
          end
        end
      end
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :sign_up_ip
      row :confirmed_at
      row :confirmation_sent_at
      row :unconfirmed_email
      row :password_reset
      row :is_active
      row :created_at
      row :updated_at

    end
    active_admin_comments

  end


  form do |f|
    f.inputs "User Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end

      f.input :birthday ,:start_year=>1900
      f.input :gender,:as => :select ,:collection=>["Male","Female"],:prompt=>true
      f.input :country,:as => :select,:collection=>["Afghanistan" ,"Albania","Algeria","Andorra","Angola","Antigua and Barbuda","Argentina","Armenia","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bhutan","Bolivia","Bosnia and Herzegovina","Botswana","Brazil",
"Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Cape Verde","Central African Republic","Chad","Chile","China","Colombi","Comoros","Congo (Brazzaville)","Congo","Costa Rica","Cote d'Ivoire","Croatia","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","East Timor (Timor Timur)","Ecuador","Egypt","El Salvador","Equatorial Guinea",
"Eritrea","Estonia","Ethiopia","Fiji","Finland","France","Gabon","Gambia, The","Georgia","Germany","Ghana","Greece","Grenada","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Honduras","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Kiribati","Korea, North","Korea, South","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Mauritania","Mauritius",
"Mexico","Micronesia""Moldova","Monaco","Mongolia","Morocco","Mozambique","Myanmar","Namibia","Nauru","Nepal","Netherlands","New Zealand","Nicaragua","Niger","Nigeria","Norway","Oman","Pakistan","Palau","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Qatar","Romania","Russia","Rwanda","Saint Kitts and Nevis","Saint Lucia","Saint Vincent","Samoa","San Marino","Sao Tome and Principe","Saudi Arabia","Senegal","Serbia and Montenegro",
"Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","Spain","Sri Lanka","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Togo","Tonga","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan""Tuvalu","Uganda","Ukraine","United Arab Emirates","United Kingdom","United States","Uruguay","Uzbekistan","Vanuatu","Vatican City","Venezuela","Vietnam","Yemen","Zambia","Zimbabwe"] , :prompt=>true
      f.input :referral_code_id,:as=> :select,:collection => Hash[ReferralCode.all.map{|b| [b.company_name,b.id]}],:prompt=>true
      f.input :is_active ,:as=> :radio
      f.input :question_id,:as => :select,:collection =>  Hash[Question.all.map{|b| [b.question,b.id]}],:prompt=>true
      f.input :answer
      f.input :sign_up_ip
      f.input :password_reset ,:as=> :radio
      f.inputs :name => "Subscription", :for => :subscription do |subscription|
        subscription.input :end_date
      end
   end
    f.actions
   end


end
