class UserMailer < ApplicationMailer
  def password_setting(user)
    @user = user
    mail(to: user.email, subject: "nebill パスワード設定のご案内")
  end
end
