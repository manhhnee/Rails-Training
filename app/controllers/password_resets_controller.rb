# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration, only: %i(edit create update)
  before_action :check_password_presence, only: :update

  def new; end

  def edit; end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t("layouts.messages.email_instructions")
    redirect_to root_url
  end

  def update
    if @user.update(user_params)
      log_in(@user)
      @user.update_column :reset_digest, nil
      flash[:success] = t("layouts.messages.password_update_success")
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email] || params.dig(:password_reset, :email).downcase
    return if @user

    flash[:danger] = t "layouts.messages.user_not_found"
    render :new
  end

  def valid_user
    return if @user.activated && @user.authenticate?(:reset, params[:id])

    flash[:danger] = t("layouts.messages.user_actived")
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t("layouts.messages.password_expired")
    redirect_to new_password_reset_url
  end

  def check_password_presence
    return unless user_params[:password].empty?

    @user.errors.add :password, t("layouts.messages.password_reset_error")
    render :edit
  end
end
