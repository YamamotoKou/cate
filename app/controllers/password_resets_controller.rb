class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "送信されたメールをご確認ください"
      redirect_to root_url
    else
      flash[:danger] = "正しいメールアドレスを入力してください"
      redirect_to new_password_reset_path
    end
  end

  def edit
  end

  def update
    # 新しいパスワードがから文字列になっていないか
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    # 新しいパスワードが正しければ，更新する．
    elsif @user.update(user_params)
      log_in @user
      # 再設定に成功したら，最後再設定されないようにする．
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    # 無効なパスワードがあれば失敗させる．
    else
      render 'edit'                                     # （2）への対応
    end
  end

  private

  # paramsハッシュ全体を初期化するという行為はセキュリティ上、極めて危険なので必要な属性のみ許可
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # フォームのemailでユーザーを特定する
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "パスワード再設定の有効期限が切れています．"
        redirect_to new_password_reset_url
      end
    end
    
end