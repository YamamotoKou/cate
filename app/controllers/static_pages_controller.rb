class StaticPagesController < ApplicationController
  # before_action :logged_in_user
  def start
    render :layout => nil
  end
end