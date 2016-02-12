class Api::ProjectsController < Api::ApiController
  before_action :set_project, only: [:show]

  def index
    @projects = Project.all
    render json: @projects, status: :ok
  end

  def create
    @project = Project.new(project_param)
    @project.save!

    render_action_model_success_message(@project, :create)
  rescue
    render_action_model_fail_message(@project, :create)
  end

  def show
    render json: @project, status: :ok
  end

private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_param
    params.require(:project).permit(
      :key,
      :name,
      :contracted,
      :contract_on,
      :contract_type,
      :start_on,
      :end_on,
      :amount,
      :billing_company_name,
      :billing_department_name,
      :billing_address,
      :billing_zip_code,
      :billing_memo,
      :orderer_company_name,
      :orderer_department_name,
      :orderer_address,
      :orderer_zip_code,
      :orderer_memo,
      billing_personnel_names: [],
      orderer_personnel_names: [],
    )
  end
end
