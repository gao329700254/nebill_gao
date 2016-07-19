module SessionConcern
  extend ActiveSupport::Concern

  included do
    before_action :current_user, :require_login
  end

private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_login
    return if current_user
    respond_to do |format|
      format.html { redirect_to root_path, error: 'unauthorized', flash: { error: t('helpers.unauthorized') } }
      format.json { render(json: { message: t('helpers.unauthorized') }, status: :unauthorized) }
    end
  end

  def require_login_with_admin
    return if current_user.is_admin?
    respond_to do |format|
      format.html { redirect_to root_path, error: 'unauthorized', flash: { error: t('helpers.unauthorized') } }
      format.json { render(json: { message: t('helpers.unauthorized') }, status: :unauthorized) }
    end
  end
end
