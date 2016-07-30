class Api::BillsController < Api::ApiController
  before_action :set_project, only: [:create]
  before_action :set_bill   , only: [:show, :update]

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

  def show
    render json: @bill, status: :ok
  end

  def update
    @bill.attributes = bill_param
    @bill.save!

    render_action_model_success_message(@bill, :update)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@bill, :update)
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_bill
    @bill = Bill.find(params[:id])
  end

  def bill_param
    params.require(:bill).permit(
      :key,
      :amount,
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
    ]
  end
end
