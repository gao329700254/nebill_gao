class Api::UsersController < Api::ApiController
  before_action :require_login_with_admin, only: [:create]
  before_action :set_project, only: [:index], if: -> { params.key? :project_id }

  def index
    @users =  if @project
                @project.users
              else
                User.all
              end

    render(
      json: @users,
      except: %i(
        provider
        uid
        persistence_token
        login_count
        failed_login_count
        current_login_at
        last_login_at
      ),
      status: :ok,
    )
  end

  def create
    @user = User.new(user_param)
    @user.save!

    render_action_model_success_message(@user, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@user, :create)
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def user_param
    params.require(:user).permit(:email, :role, :is_admin)
  end
end
