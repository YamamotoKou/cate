class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Cate 仮登録通知"
  end

  def password_reset
    @greeting = "やあ"

    mail to: "to@example.org"
  end
end
