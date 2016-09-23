class Api::PartnersController < Api::ApiController
  before_action :set_project, only: [:index], if: -> { params.key? :project_id }

  def index
    @partners = if @project
                  @project.partners
                else
                  Partner.all
                end

    render 'index', formats: 'json', handlers: 'jbuilder'
  end

  def create
    @partner = Partner.new(partner_param)
    @partner.save!

    render_action_model_success_message(@partner, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@partner, :create)
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def partner_param
    params.require(:partner).permit(
      :name,
      :email,
      :company_name,
    )
  end
end
