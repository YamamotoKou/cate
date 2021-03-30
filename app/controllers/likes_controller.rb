class LikesController < ApplicationController

  def create
    @like = Like.new(micropost_id: params[:micropost_id], user_id: current_user.id)
    @like.save
    redirect_back(fallback_location: home_path)
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy
    redirect_back(fallback_location: home_path)
  end

  def show
  end

end
