class Admin::PagesController < ApplicationController
  def users
    can?(:manage, User) || redirect_to(root_path)
  end
end
