class HomeController < ApplicationController
  layout "sing_in"

  def index
    if current_user
      redirect_to practice_address
    end
  end

  def jplayer
    render :layout => nil
  end

  def m4a_jplayer
    render :layout => nil
  end

end