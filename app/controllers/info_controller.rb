class InfoController < ApplicationController
  layout "static"

  def about

  end

  def pricing

  end

  def partners

  end

  def features

  end

  def legal

  end

  def terms_of_services

  end

  def contact_us
    unless params[:contact_us].blank?
      UserMailer.setup_partners_account(params[:contact_us]).deliver
      flash[:notice] = "Your contact information  has been sent."
      redirect_to contact_us_info_index_path
    end
  end

  def practice_page
     redirect_to practice_address
  end

end