# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Pagy::Backend
  include SessionsHelper

  private

  def logged_in_user
    return if logged_in?

    flash[:danger] = t("layouts.messages.user_not_logged_in")
    store_location
    redirect_to login_path
  end
end
