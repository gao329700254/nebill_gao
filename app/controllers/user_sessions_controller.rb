class UserSessionsController < ApplicationController
  def create
    auth = omniauth_auth

    case auth&.provider
    when 'google_oauth2'
      user = User.find_by(provider: auth.provider, uid: auth.uid) || User.register_by!(auth)

      @session = UserSession.new(user)
    when nil
      @session = UserSession.new(user_session_params.to_h)
    end

    @session.save!

    create_redirect
  rescue => e
    logger.error e.message
    redirect_to root_path, flash: { error: t('action.login.fail') }
  end

  def omniauth_auth
    request.env['omniauth.auth']
  end

  def destroy
    current_user_session.destroy
    redirect_to root_path, flash: { success: t('action.logout.success') }
  rescue => e
    logger.error e.message
    redirect_to root_path, flash: { error: t('action.logout.fail') }
  end

  def user_session_params
    params.require(:user_session).permit(:email, :password)
  end

  def create_redirect
    if session[:request_url].blank?
      redirect_to @session.user.role.outer? ? approval_list_path : project_list_path, flash: { success: t('action.login.success') }
    else
      redirect_to session[:request_url], flash: { success: t('action.login.success') }
      session[:request_url] = nil
    end
  end
end
