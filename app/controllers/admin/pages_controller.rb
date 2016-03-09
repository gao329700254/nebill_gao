class Admin::PagesController < ApplicationController
  before_action :require_login_with_admin

  def users
  end
end
