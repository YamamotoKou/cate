class LikesController < ApplicationController

  def create
    @micropost = Micropost.find(params[:micropost_id])
    @like = Like.new(micropost_id: params[:micropost_id],
                     user_id: current_user.id)
    @like.save
    redirect_back(fallback_location: home_url)
    # respond_to do |format|
    #   format.html { redirect_back(fallback_location: home_url) }
    #   format.js
    # end
  end

  def destroy
    @like = Like.find_by(micropost_id: params[:micropost_id])
    @micropost = Micropost.find(@like.micropost_id)
    @like.destroy
    redirect_back(fallback_location: home_url)
    # respond_to do |format|
    #   format.html { redirect_back(fallback_location: home_url) }
    #   format.js
    # end
  end
end