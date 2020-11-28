class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "糧を給仕しました！"
      redirect_to home_path
    else
      @feed_items = current_user.feed.page(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "投稿を削除しました"
    redirect_to request.referrer || root_url # 一つ前のURLを返すorルート
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end

    # paramsのid（削除対象のマイクロポスト）はcurrent_userは所持しているか調べる．
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end