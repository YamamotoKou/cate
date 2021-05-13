class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :new, :home]
  before_action :correct_user,   only: :destroy

  def home
    @user = current_user
    #投稿フォームのためのインスタンス変数
    @micropost = current_user.microposts.build if logged_in?
    @feed_items = @user.feed.page(params[:page])
    @trend_posts = Micropost.trend
  end

  def new
    @user = current_user
    @micropost = @user.microposts.build
    @micropost.contents.build
    @trend_posts = Micropost.trend
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "投稿しました"
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

  def search
    if params[:keyword]
      @microposts = Micropost.search(params[:keyword])
      @feed_items = @microposts.page(params[:page])
    end
  end

  private

    def micropost_params
      params.require(:micropost).permit(:text,
                                        :image,
                                        contents_attributes: [:title,
                                                             :sentence,
                                                             :price,
                                                             :status])
    end

    # paramsのid（削除対象のマイクロポスト）はcurrent_userは所持しているか調べる．
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end