class BookmarksController < ApplicationController
  def create
    current_user.bookmarks.create!(micropost_id: params[:micropost_id])
    redirect_back(fallback_location: home_path)
  end

  def destroy
    @user = current_user
    @micropost = Micropost.find(params[:micropost_id])
    @bookmark = Bookmark.find_by(user_id: @user.id, micropost_id: @micropost.id)
    @bookmark.destroy
    redirect_back(fallback_location: home_path)
  end

  def show
    @title = "ブックマーク"
    @user  = User.find(current_user.id)
    @microposts  = @user.bookmark_posts.page(params[:page])
    @trend_posts = Micropost.trend
    render 'show_bookmarks'
  end
end