class Api::ProjectGroupsController < Api::ApiController
  before_action :set_project_group, only: [:update]

  def index
    @project_groups = ProjectGroup.all
    render json: @project_groups, status: :ok
  end

  def create
    @project_group = ProjectGroup.new(project_group_param)
    @project_group.save!

    render_action_model_success_message(@project_group, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@project_group, :create)
  end

  def update
    @project_group.attributes = project_group_param
    @project_group.save!

    render_action_model_success_message(@project_group, :update)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@project_group, :update)
  end

private

  def set_project_group
    @project_group = ProjectGroup.find(params[:id])
  end

  def project_group_param
    params.require(:project_group).permit(:name)
  end
end
