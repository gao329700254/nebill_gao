class Api::BillIssuedsController < Api::ApiController
  before_action :set_project, only: [:index], if: -> { params.key? :project_id }
  before_action :set_bill   , only: [:show, :update]

  def index
    @bills = Bill.issued_search_result(params[:expected_deposit_on_start], params[:expected_deposit_on_end]).where(status: [:issued, :confirmed])

    render 'index', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def show
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
      :id,
      :deposit_on,
      :status,
      :deposit_confirmed_memo,
    )
  end
end
