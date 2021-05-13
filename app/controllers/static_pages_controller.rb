class StaticPagesController < ApplicationController
  def start
    if current_user
      redirect_to home_url
    else
      render :layout => nil
    end
  end
end