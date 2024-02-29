# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user.authenticate params.dig(:session, :password)
      log_in @user
      params.dig(:session, :remember_me) == "1" ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash.now[:danger] = t("invalid_email_password_combination")
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def load_user
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return if @user

    flash.now[:danger] = t("layouts.messages.user_not_found")
    render :new
  end
end
