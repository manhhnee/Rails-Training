# frozen_string_literal: true

class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      flash[:success] = t("layouts.messages.micropost_create")
      redirect_to root_url
    else
      @pagy, @feed_items = pagy current_user.feed, items: Settings.PAGE_10
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t("layouts.messages.micropost_deleted")
    else
      flash[:danger] = t("layouts.messages.deleted_fail")
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t("layouts.messages.micropost_invalid")
    redirect_to request.referer || root_url
  end
end
