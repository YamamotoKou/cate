class StaticPagesController < ApplicationController
  before_action :logged_in_user
  def home
    @user = current_user
    @microposts = @user.microposts.page(params[:page])
  end
  def start
    render :layout => nil
  end
end
