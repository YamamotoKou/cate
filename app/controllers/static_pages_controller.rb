class StaticPagesController < ApplicationController
  def home
    render :layout => nil
  end
end
