class Admin::PagesController < ApplicationController
  before_action :set_user        , only: [:user_show]
  before_action :redirect_user   , only: [:users, :user_show]

  def users
  end

  def user_show
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def redirect_user
    can?(:manage, User) || redirect_to(root_path)
  end
end
