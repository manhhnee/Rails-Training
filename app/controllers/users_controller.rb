# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = I18n.t("layouts.messages.success")
      redirect_to @user
    else
      flash[:error] = I18n.t("layouts.messages.error")
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :birthday, :gender, :password, :password_confirmation
  end
end
