# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :load_user, :check_authenticate, :check_activation, only: :create

  def new; end

  def create
    reset_session
    params.dig(:session, :remember_me) == "1" ? remember(@user) : forget(@user)
    log_in @user
    redirect_back_or @user
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

  def check_authenticate
    return if @user.authenticate(params.dig(:session, :password))

    flash.now[:danger] = t("invalid_email_password_combination")
    render :new
  end

  def check_activation
    return unless @user && !@user.activated?

    flash[:warning] = t("not_active")
    redirect_to root_url
  end
end
