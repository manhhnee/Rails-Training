# frozen_string_literal: true

class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if !user&.activated && user.authenticate?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "layouts.messages.account_active"
      redirect_to user
    else
      flash[:danger] = t "layouts.messages.invalid_link"
      redirect_to root_url
    end
  end
end
