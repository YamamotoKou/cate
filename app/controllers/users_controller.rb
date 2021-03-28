class UsersController < ApplicationController
  #未ログインに編集させない．
  before_action :logged_in_user, only: [:edit, :update, :destroy, :folloeing, :followers]
  #自分以外のユーザーに編集をさせない．
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroys

  def index
    @users = User.where(activated: true)
    # @users = User.all
  end

  def show
    @user = User.find_by(name: params[:id])
    @micropost = @user.microposts.build
    @microposts = @user.microposts.page(params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "送信されたメールをご確認ください．"
      redirect_to root_url
      # flash[:success] = "cateへようこそ！"
      # redirect_to @user
      # = redirect_to user_url(@user)
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find_by(name: params[:id])
    user.destroy
    flash[:success] = "#{user.name}を削除しました"
    redirect_to users_url
  end

  def following
    @title = "フォロー"
    @user  = User.find_by(name: params[:id])
    @users = @user.following.page(params[:page])
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find_by(name: params[:id])
    @users = @user.followers.page(params[:page])
    render 'show_follow'
  end

  private

  def user_params
  params.require(:user).permit(:name, :email, :password,
                               :password_confirmation, :avatar)
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
