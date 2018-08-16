module SessionConcern
  extend ActiveSupport::Concern

  included do
    authorize_resource
    before_action :current_user

    rescue_from CanCan::AccessDenied do |exception|
      logger.info { "rescue_from CanCan::AccessDenied action=#{exception.action}, subject=#{exception.subject}" }
      respond_to do |format|
        format.html do
          if current_user.present? && !(exception.action == :users && exception.subject == Page)
            redirect_to project_list_path, error: 'unauthorized', flash: { error: t('helpers.unauthorized') }
          else
            redirect_to root_path, error: 'unauthorized', flash: { error: t('helpers.unauthorized') }
          end
        end
        format.json { render(json: { message: t('helpers.unauthorized') }, status: :unauthorized) }
      end
    end
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

  def current_ability
    Ability.new(current_user)
  end
end
