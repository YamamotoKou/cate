class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user &.authenticate(params[:session][:password])
      #user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
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
