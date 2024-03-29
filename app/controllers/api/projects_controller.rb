# rubocop:disable Metrics/ClassLength
class Api::ProjectsController < Api::ApiController
  before_action :set_project, only: [:update, :select_status, :last_updated_at, :bill_default_values, :destroy], if: -> { params.key? :id }
  before_action :check_names, only: [:update]

  def index
    @projects = Project.where(group_id: params[:group_id].presence)

    render 'index', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def create
    params[:project] = JSON.parse(params[:project]) if params[:project].class == String
    @project = Project.new(project_params)
    @project.create_in_nebill_and_sf!(params[:file])
    render_action_model_flash_success_message_create(@project, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@project, :create)
  end

  def show
    @project = if params[:bill_id]
                 Bill.find_by(id: params[:bill_id]).project
               else
                 Project.find(params[:id])
               end
    render 'show', format: 'json', handlers: 'jbuilder', status: :ok
  end

  def update
    @project.update_in_nebill_and_sf!(project_params, params[:file])

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

  def search_result
    @projects = Project.select_by_start_on_and_end_on(params[:start], params[:end])
    @projects = Projects::SortService.new(@projects).execute

    render 'index', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def bill_default_values
    # 正規表現でマッチした部分を用いて、請求日を算出する
    now                   = Time.zone.now
    @project.payment_type =~ /\Abill_on_(.+)_and_payment_on_(.+)\z/
    bill_on               = view_context.calc_date(now, Regexp.last_match(1))

    # 支払い条件と請求日から入金予定日を算出する
    expected_deposit_on   = @project.calc_expected_deposit_on(@project.payment_type, bill_on)

    # TODO(maeda)：
    # 請求先会社名については、[NEBILL-337]取引先担当者機能が実装されたのちに、修正が必要
    result = {
      cd:                  @project.generate_bill_cd,
      project_name:        @project.name,
      company_name:        @project.billing_company_name,
      amount:              @project.amount,
      delivery_on:         @project.end_on,
      acceptance_on:       @project.end_on,
      payment_type:        @project.payment_type,
      bill_on:             bill_on,
      expected_deposit_on: expected_deposit_on,
    }

    render json: result, status: :ok
  end

  def destroy
    if @project.destroy
      @project.destroy_in_sf
      render_action_model_flash_success_message(@project, :destroy)
    else
      render_action_model_fail_message(@project, :destroy)
    end
  end

  def load_partner_user
    @employee = Employee.all
    render json: @employee, status: :ok
  end

  def members_and_partners
    @members_and_partners = Member.where(project_id: params[:id], type: params[:type]).includes(:employee)
    render 'members_and_partners', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def update_project_approval
    @services ||= ApprovalUsers::UpdateStatusService.new(update_params: update_params, current_user: @current_user)
    if @services.execute
      update_status
      @services.approval.update(status: 'disconfirm') if update_params[:button] == 'disconfirm'
      update_approval_notice
      update_execut_success
    else
      execut_fail
    end
  end

private

  def set_project
    @project = Project.find(params[:id])
  end

  def update_params
    params.permit(
      :approval_id,
      :button,
      :comment,
    )
  end

  def update_execut_success
    action_model_flash_success_message(Approval.new, params[:button])
    redirect_to agreement_list_path('agreementProjectList')
  end

  def execut_fail
    flash[:error] = I18n.t('action.update.fail', model: I18n.t('activerecord.models.approval'))
    redirect_to(:back)
  end

  def update_status
    @project = Project.find(params[:project_id])
    @project.status = 'receive_order' if params[:button] == 'permission'
    @project.save
  end

  def update_approval_notice
    approval = @services.approval
    if params[:button] == 'permission'
      ProjectMailer.permission_project_approval(user: approval.created_user, approval: approval).deliver_now
      Chatwork::Project.new(approval: approval, to_user: approval.created_user).notify_permited
    elsif params[:button] == 'disconfirm'
      ProjectMailer.disconfirm_project_approval(user: approval.created_user, approval: approval).deliver_now
      Chatwork::Project.new(approval: approval, to_user: approval.created_user).notify_disconfirm
    end
  end

  def check_names
    order = params[:project][:orderer_personnel_names]
    billing = params[:project][:billing_personnel_names]
    params[:project][:orderer_personnel_names] = order.split(",") if order
    params[:project][:billing_personnel_names] = billing.split(",") if billing
  end

  # rubocop:disable Metrics/MethodLength
  def project_params
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
        :working_period_start,
        :working_period_end,
        :man_month,
        :_destroy,
      ],
    )
  end
  # rubocop:enable Metrics/MethodLength
end
# rubocop:enable Metrics/ClassLength
