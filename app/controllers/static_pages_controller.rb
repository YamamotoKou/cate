class StaticPagesController < ApplicationController
  before_action :logged_in_user
  def home
    @user = current_user
    @micropost = current_user.microposts.build if logged_in?
    @feed_items = @user.feed.page(params[:page])
    @microposts = @user.microposts.page(params[:page])
  end
  def start
    render :layout => nil
  end
end
