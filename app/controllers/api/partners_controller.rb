class Api::PartnersController < Api::ApiController
  before_action :set_bill, only: [:index], if: -> { params.key? :bill_id }
  before_action :set_project, only: [:index], if: -> { params.key? :project_id }
  before_action :set_partner, only: [:update, :show, :destroy]

  def index
    @partners = if @bill
                  @bill.partners.order(:company_name, :id)
                elsif @project
                  Partner.where(id: @project.partners.pluck(:id))
                else
                  Partner.all
                end

    @partners.order!(updated_at: :desc)

    render 'index', formats: 'json', handlers: 'jbuilder'
  end

  def show
    render 'show', formats: 'json', handlers: 'jbuilder'
  end

  def create
    @partner = Partner.new(partner_params)
    @partner.save!

    render_action_model_success_message(@partner, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@partner, :create)
  end

  def update
    @partner.attributes = partner_params
    @partner.save!

    render_action_model_success_message(@partner, :update)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@partner, :update)
  end

  def destroy
    if @partner.destroy
      render_action_model_success_message(@partner, :destroy)
    else
      render_action_model_fail_message(@partner, :destroy)
    end
  end

private

  def set_bill
    @bill = Bill.find(params[:bill_id])
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_partner
    @partner = Partner.find(params[:id])
  end

  def partner_params
    params.require(:partner).permit(
      :cd,
      :name,
      :email,
      :client_id,
    )
  end
end
