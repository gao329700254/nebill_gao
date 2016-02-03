class Api::ProjectsController < Api::ApiController
  def index
    # TODO(ishida): implement after `create` implemented.
  end

  def create
    @project = Project.new(project_param)
    @project.save!

    render_action_model_success_message(@project, :create)
  rescue
    render_action_model_fail_message(@project, :create)
  end

private

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
