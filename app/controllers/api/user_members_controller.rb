class Api::UserMembersController < Api::ApiController
  before_action :set_project, only: [:create]

  def create
    @member = @user.join!(@project)

    render_action_model_success_message(@member, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@member, :create)
  end

  def destroy
    @member = Member.find(params[:user_id])

    if @member.destroy
      render_action_model_success_message(@member, :destroy)
    else
      render_action_model_fail_message(@member, :destroy)
    end
  end

private

  def set_project
    @project = Project.find(params[:project_id])
    @user = Employee.find(params[:user_id])
  end
end
