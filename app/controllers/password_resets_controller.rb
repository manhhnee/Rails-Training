class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email).downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t("layouts.messages.email_instructions")
      redirect_to root_url
    else
      flash.now[:danger] = t("layouts.messages.email_not_found")
      render :new
    end
  end

  def update
    if user_params[:password].empty?
      @user.errors.add :password, t("layouts.messages.password_reset_error")
      render :edit
    elsif @user.update user_params
      log_in(@user)
      @user.update_column :reset_digest, nil
      flash[:success] = t("layouts.messages.password_update_success")
      redirect_to @user
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
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
end
