ActiveAdmin.register ReferralCode do
  index do
    selectable_column
    column :company_name
    column "Referral Url" do |code|
      link_to "http://#{request.host}/?ref=#{code.code}","http://#{request.host}/?ref=#{code.code}", target:"_blank"
    end
    column :company_url do |t|
      link_to t.company_url, t.company_url, target:"_blank"
    end
    column :created_at
    column :updated_at

    default_actions
  end

  filter :company_name

  show do |ad|
    attributes_table do
      row :company_name
      row :code
      row "Referral Url" do |code|
        link_to "http://#{request.host}/?ref=#{code.code}","http://#{request.host}/?ref=#{code.code}", target:"_blank"
      end
      row :company_url do |t|
        link_to t.company_url, t.company_url, target:"_blank"
      end
      row "LOGO" do
        image_tag ad.logo.url(:thumb).safe_url
      end
      row :is_active
      row :created_at
      row :updated_at

    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Referral Codes" do
      f.input :company_name
      f.input :logo , as: :file
      if f.object.new_record?
        f.input :code , input_html: { value: SecureRandom.hex(6)  }
      else
        f.input :code
      end
      if f.object.new_record?
        f.input :company_url , input_html: { value: "http://"  }
      else
        f.input :company_url
      end
      if f.object.new_record?
        f.input :is_active ,:as=> :radio, input_html:{checked:"checked"}
      else
        f.input :is_active ,:as=> :radio
      end

    end
    f.actions
  end


end
