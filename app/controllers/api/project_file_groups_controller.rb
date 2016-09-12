class Api::ProjectFileGroupsController < Api::ApiController
  before_action :set_project, only: [:index, :create]

  def index
    @project_file_groups = @project.file_groups
    render json: @project_file_groups, status: :ok
  end

  def create
    @project_file_group = @project.file_groups.build(project_file_group_param)
    @project_file_group.save!

    render_action_model_success_message(@project_file_group, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@project_file_group, :create)
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def project_file_group_param
    params.require(:project_file_group).permit(:name)
  end
end
