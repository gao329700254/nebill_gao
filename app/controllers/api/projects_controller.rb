class Api::ProjectsController < Api::ApiController
  before_action :set_project, only: [:show, :update, :select_status, :last_updated_at, :bill_default_values, :destroy], if: -> { params.key? :id }

  def index
    @projects = if params.key? :group_id
                  Project.where(group_id: params[:group_id].presence)
                else
                  Project.all
                end

    render json: @projects, status: :ok
  end

  def create
    @project = Project.new(project_param)
    @project.save!

    render_action_model_success_message(@project, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@project, :create)
  end

  def show
    render json: @project, status: :ok
  end

  def update
    @project.attributes = project_param
    @project.save!

    render_action_model_success_message(@project, :update)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@project, :update)
  end

  def select_status
    @select_status = if @project.bills.pluck(:deposit_on).any?
                       Project.status.options
                     else
                       Project.status.options.reject { |s| s.include?("finished") }
                     end

    render json: @select_status, status: :ok
  end

  def last_updated_at
    latest_version = Version.where(project_id: @project.id).order(:created_at).last
    if latest_version
      @last_updated_at = latest_version.created_at.in_time_zone('Tokyo')
      @user_name = User.find(latest_version.whodunnit).name if latest_version.whodunnit
    else
      @last_updated_at = @project.updated_at
    end
    @user_name ||= ''

    render 'last_updated_at', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def bill_default_values
    now = Time.zone.now
    @project.payment_type =~ /\Abill_on_(.+)_and_payment_on_(.+)\z/
    result = {
      amount:         @project.amount,
      delivery_on:    @project.end_on,
      acceptance_on:  @project.end_on,
      payment_type:   @project.payment_type,
      bill_on:        view_context.calc_date(now, Regexp.last_match(1)),
      deposit_on:     nil,
    }

    render json: result, status: :ok
  end

  def destroy
    if @project.destroy
      render_action_model_flash_success_message(@project, :destroy)
    else
      render_action_model_fail_message(@project, :destroy)
    end
  end

private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_param
    params.require(:project).permit(
      :group_id,
      :cd,
      :name,
      :contracted,
      :contract_on,
      :contract_type,
      :is_using_ses,
      :is_regular_contract,
      :status,
      :start_on,
      :end_on,
      :amount,
      :payment_type,
      :estimated_amount,
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
