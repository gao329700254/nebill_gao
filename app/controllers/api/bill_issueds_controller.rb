class Api::BillIssuedsController < Api::ApiController
  before_action :set_project, only: [:index, :create], if: -> { params.key? :project_id }
  before_action :set_bill   , only: [:show, :update, :destroy]

  def index
    @bills = Bill.all.issued_search_result(params[:start], params[:end]).where(status: 'issued').or(Bill.all.issued_search_result(params[:start], params[:end]).where(status: 'confirmed'))

    render 'index', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def show
    latest_version = Version.where(bill_id: @bill.id).order(:created_at).last
    if latest_version
      @last_updated_at = latest_version.created_at
      @user = User.find(latest_version.whodunnit) if latest_version && latest_version.whodunnit
    else
      @last_updated_at = @bill.updated_at
    end

    render 'show', formats: 'json', handlers: 'jbuilder', status: :ok
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
      :cd,
      :amount,
      :delivery_on,
      :acceptance_on,
      :payment_type,
      :bill_on,
      :deposit_on,
      :memo,
      :status,
      :deposit_confirmed_memo,
    )
  end

  def bill_index_project_cols
    [
      :name,
      :billing_company_name,
    ]
  end
end
