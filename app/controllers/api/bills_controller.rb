class Api::BillsController < Api::ApiController
  before_action :set_project, only: [:index, :create], if: -> { params.key? :project_id }
  before_action :set_bill   , only: [:show, :update, :destroy]

  def index
    @bills = if @project
               @project.bills.order(created_at: :desc)
             else
               Bill.includes(:project).order(created_at: :desc)
             end

    render 'index', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def create
    @bill = @project.bills.build(bill_param)
    @bill.save!

    render_action_model_success_message(@bill, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@bill, :create)
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

  def search_result
    @bills = if params[:start].present? && params[:end].present?
               Bill.between(params[:start], params[:end]).includes(:project)
             elsif params[:start].present?
               Bill.gteq_start_on(params[:start]).includes(:project)
             elsif params[:end].present?
               Bill.lteq_end_on(params[:end]).includes(:project)
             else
               Bill.all.includes(:project)
             end

    render 'index', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def destroy
    if @bill.destroy
      render_action_model_flash_success_message(@bill, :destroy)
    else
      render_action_model_fail_message(@bill, :destroy)
    end
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
      :expected_deposit_on,
      :deposit_on,
      :memo,
      :status,
      :create_user_id,
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
