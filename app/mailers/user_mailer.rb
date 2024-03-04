# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: t("layouts.messages.account_activation")
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: t("layouts.messages.password_reset")
  end
end
