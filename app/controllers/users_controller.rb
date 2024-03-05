# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.sort_by_name, items: Settings.PAGE_10
  end

  def show
    @page, @microposts = pagy @user.microposts, items: Settings.PAGE_10
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t("check_email_noti")
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = I18n.t("layouts.messages.updated_success")
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = I18n.t("layouts.messages.user_deleted")
      redirect_to root_path
    else
      flash[:danger] = I18n.t("layouts.messages.deleted_fail")
      redirect_to user_path
    end
  end

  private

  def admin_user
    return if current_user.admin?

    redirect_to root_path
    flash[:warning] = t("layouts.messages.admin_error")
  end

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:warning] = t("layouts.messages.user_not_found")
    redirect_to root_path
  end

  def correct_user
    return if current_user?(@user)

    flash[:error] = t("layouts.messages.edit_error")
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :name, :email, :birthday, :gender, :password, :password_confirmation
  end
end
