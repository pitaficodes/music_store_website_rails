module ApplicationHelper

  def reference_logo
    if current_user
      ref_logo = current_user.referral_code
      if ref_logo && ref_logo.is_active == true
        link_to image_tag(ref_logo.logo.url(:thumb).safe_url), ref_logo.company_url, :target => "_blank"
      end
    end
  end
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def referral_logo
    row = params[:ref].blank? ? current_user.try(:referral_code) : ReferralCode.referral_url(params[:ref]).first
    row.present? ? (link_to (image_tag row.logo.url(:thumb).safe_url) , row.company_url , target: "_blank") : ""
  end

  def user_last_inst_id
    user = User.find(current_user.id)
    if !user.blank?
       user.last_instrument_id
    else
      ""
    end
  end

  def get_sub_plan sub
    if sub == 1
      cat= "Student"
    elsif sub == 6
      cat = "Professional"
    else
      cat = "Virtuoso"
    end
  end

end
