class Api::BillsController < Api::ApiController
  before_action :set_project, only: [:create]

  def index
    @bills = Bill.all.includes(:project)

    render json: @bills, include: { project: { only: bill_index_project_cols } }, status: :ok
  end

  def create
    @bill = @project.bills.build(bill_param)
    @bill.save!

    render_action_model_success_message(@bill, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@bill, :create)
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def bill_param
    params.require(:bill).permit(
      :key,
      :delivery_on,
      :acceptance_on,
      :payment_on,
      :bill_on,
      :deposit_on,
      :memo,
    )
  end

  def bill_index_project_cols
    [
      :name,
      :billing_company_name,
      :amount,
    ]
  end
end
