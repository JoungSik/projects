class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: t("email.passwords.reset.subject"), to: @user.email
  end
end
