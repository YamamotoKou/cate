class UsersController < ApplicationController
  #未ログインに編集させない．
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  #別のユーザーに編集をさせない．
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroys

  def index
    @users = User.where(activated: true)
    # @users = User.all
  end

  def show
    @user = User.find_by(name: params[:id])
    @micropost = @user.microposts.build
    # 有効化されていなければリダイレクトさせる
    # redirect_to root_url and return unless @user.activated?
    @microposts = @user.microposts.page(params[:page])
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
    user = User.find(params[:id])
    user.destroy
    flash[:success] = "#{user.name}を削除しました"
    redirect_to users_url
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
