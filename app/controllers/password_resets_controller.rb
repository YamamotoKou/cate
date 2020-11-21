class PasswordResetsController < ApplicationController

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
      flash.now[:danger] = "正しいメールアドレスを入力してください"
      render 'new'
    end
  end

  def edit
  end
end