class Api::UsersController < Api::ApiController
  before_action :set_project, only: [:index], if: -> { params.key? :project_id }
  before_action :set_bill, only: [:index], if: -> { params.key? :bill_id }
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users =  if @bill
                @bill.users
              elsif @project
                User.where(id: @project.users.pluck(:id))
              else
                User.all
              end

    @users.order!(id: :asc)

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
    @user.save!(context: :whencreate)

    render_action_model_success_message(@user, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@user, :create)
  end

  def show
    render(
      json: @user,
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

  def update
    @user.attributes = user_param
    @user.save!

    render_action_model_success_message(@user, :update)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@user, :update)
  end

  def destroy
    if @user.destroy
      render_action_model_flash_success_message(@user, :destroy)
    else
      render_action_model_fail_message(@user, :destroy)
    end
  end

  def roles
    @roles = t('enumerize.role')
    render json: @roles, status: :ok
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_bill
    @bill = Bill.find(params[:bill_id])
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_param
    params.require(:user).permit(:name, :email, :role, :default_allower, :chatwork_id).tap do |user_param|
      if user_param[:chatwork_id].present?
        chatwork_user = Chatwork::Member.member_list.find { |mem| mem[:account_id].to_s == user_param[:chatwork_id].to_s }

        user_param[:chatwork_name] = chatwork_user[:name] if chatwork_user.present?
      end
    end
  end
end
