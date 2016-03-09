class Api::UsersController < Api::ApiController
  before_action :require_login_with_admin, only: [:create]

  def create
    @user = User.new(user_param)
    @user.save!

    render_action_model_success_message(@user, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@user, :create)
  end

private

  def user_param
    params.require(:user).permit(:email, :is_admin)
  end
end
