class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def create
    auth = request.env['omniauth.auth']
    user = User.find_by(provider: auth.provider, uid: auth.uid) || User.register_by!(auth)

    @session = UserSession.new(user)
    @session.save!
    redirect_to project_list_path, flash: { success: t('action.login.success') }
  rescue
    redirect_to root_path, flash: { error: t('action.login.fail') }
  end

  def destroy
    current_user_session.destroy
    redirect_to root_path, flash: { success: t('action.logout.success') }
  rescue
    redirect_to root_path, flash: { error: t('action.logout.fail') }
  end
end
