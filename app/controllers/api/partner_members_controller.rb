class Api::PartnerMembersController < Api::ApiController
  before_action :set_project, only: [:create]
  before_action :set_partner, only: [:create]

  def create
    @member = @project.join!(@partner.employee)

    render_action_model_success_message(@member, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@member, :create)
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_partner
    @partner = Partner.find(params[:partner_id])
  end
end
