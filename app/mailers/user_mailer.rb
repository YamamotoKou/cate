class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Cateアカウント 仮登録通知"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Cateアカウント パスワード再設定"
  end
end
