class ContentsController < ApplicationController

  def index
    if Micropost.exists?(id: params[:micropost_id])
      @micropost = Micropost.find(params[:micropost_id])
      @user = User.find_by(id: @micropost.user_id)
      @contents = @micropost.contents
      @trend_posts = Micropost.trend
    else
      redirect_to home_url
    end
  end

  def create
  end

  def destroy
  end

end