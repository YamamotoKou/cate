class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    # !user.activated?既に有効になっているユーザーを誤って再度有効化しないため
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # ユーザーの情報を更新
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url #リダイレクトではurlが求められる
    end
  end
end
