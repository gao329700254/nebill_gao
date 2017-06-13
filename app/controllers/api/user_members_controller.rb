class Api::UserMembersController < Api::ApiController
  before_action :set_project, only: [:create]
  before_action :set_user   , only: [:create, :destroy]

  def create
    @member = @user.join!(@project)

    render_action_model_success_message(@member, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@member, :create)
  end

  def destroy
    @member = @user.members.find_by(project: params[:project_id])
    @member.destroy!

    render_action_model_success_message(@member, :destroy)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@member, :destroy)
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
