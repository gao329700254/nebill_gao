# rubocop:disable Metrics/ClassLength
class Api::ProjectsController < Api::ApiController
  before_action :set_project, only: [:update, :select_status, :last_updated_at, :bill_default_values, :destroy], if: -> { params.key? :id }

  def index
    @projects = Project.where(group_id: params[:group_id].presence)

    render 'index', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def create
    @project = Project.new(project_param)
    if @project.valid?
      Project.transaction do
        @project.save!
      end
      render_action_model_success_message(@project, :create)
    else
      render_action_model_fail_message(@project, :create)
    end
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@project, :create)
  end

  def show
    @project = if params[:bill_id]
                 Bill.find_by(id: params[:bill_id]).project
               else
                 Project.find(params[:id])
               end

    render json: @project, status: :ok
  end

  def update
    @project.attributes = project_param
    @project.status = :finished if @project.unprocessed
    @project.save!

    render_action_model_success_message(@project, :update)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@project, :update)
  end

  def select_status
    @select_status = Project.status.options
    render json: @select_status, status: :ok
  end

  def last_updated_at
    latest_version = Version.where(project_id: @project.id).order(:created_at).last
    if latest_version
      @last_updated_at = latest_version.created_at.in_time_zone('Tokyo')
      @user_name = '（' + User.find(latest_version.whodunnit).name + '）' if latest_version.whodunnit
    else
      @last_updated_at = @project.updated_at
    end
    @user_name ||= ''

    render 'last_updated_at', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  # rubocop:disable Metrics/AbcSize
  def search_result
    @projects = if params[:start].present? && params[:end].present?
                  Project.between(params[:start], params[:end])
                elsif params[:start].present?
                  Project.gteq_start_on(params[:start])
                elsif params[:end].present?
                  Project.lteq_end_on(params[:end])
                else
                  Project.all
                end

    sort_project

    @projects = @projects.sort_by do |i|
      year, identifier, sequence, contract = *i.cd.scan(/(.{2})(.)(.{3})(.*)/).first
      next identifier, year, sequence, contract
    end

    render 'index', formats: 'json', handlers: 'jbuilder', status: :ok
  end
  # rubocop:enable Metrics/AbcSize

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

  def load_partner_user
    @employee = Employee.all
    render json: @employee, status: :ok
  end

private

  def set_project
    @project = Project.find(params[:id])
  end

  def sort_project
    @projects = @projects.where(Project.arel_table[:status].not_eq("finished")) if params[:today]
    @projects = @projects.where(Project.arel_table[:unprocessed].eq(true)) if params[:unprocessed]
  end

  # rubocop:disable Metrics/MethodLength
  def project_param
    params.require(:project).permit(
      :group_id,
      :cd,
      :memo,
      :name,
      :contracted,
      :unprocessed,
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
      :leader_id,
      :billing_company_name,
      :billing_department_name,
      :billing_address,
      :billing_zip_code,
      :billing_phone_number,
      :billing_memo,
      :orderer_company_name,
      :orderer_department_name,
      :orderer_address,
      :orderer_zip_code,
      :orderer_phone_number,
      :orderer_memo,
      billing_personnel_names: [],
      orderer_personnel_names: [],
      members_attributes: [
        :id,
        :employee_id,
        :type,
        :unit_price,
        :working_rate,
        :min_limit_time,
        :max_limit_time,
        :project_id,
        :_destroy,
      ],
    )
  end
  # rubocop:enable Metrics/MethodLength
end
# rubocop:enable Metrics/ClassLength
