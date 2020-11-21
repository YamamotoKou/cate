class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user &.authenticate(params[:session][:password])
      # = user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message = "アカウントが有効かされていません"
        message += "送信されたメールを確認してください"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = '入力されたユーザー名やパスワードが正しくありません。確認してからやり直してください。'
      render 'new'
    end
  end

  def destroy
    # 二つのブラウザでのログアウトのエラーを防ぐ
    log_out if logged_in?
    redirect_to root_url
  end
end