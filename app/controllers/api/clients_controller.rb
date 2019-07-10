# rubocop:disable Metrics/ClassLength
class Api::ClientsController < Api::ApiController
  def index
    @clients = Client.all.includes(:approvals)

    render json: @clients, status: :ok
  end

  def create
    @client = Client.new(client_param)
    if @client.valid?
      params[:client][:files_attributes]&.each do |file|
        @client.status = 10 if file.second[:file_type] == '10'
      end
      Client.transaction do
        @client.save!
        create_approval
      end
      create_notice if @client.status == 10
      render_action_model_success_message(@client, :create)
    else
      render_action_model_fail_message(@client, :create)
    end
  rescue
    render_action_model_fail_message(@client, :create)
  end

  def show
    @client = Client.find(params[:id])
    latest_version = Version.where(item_type: 'Client', item_id: @client.id).order(:created_at).last
    @user = User.find(latest_version.whodunnit) if latest_version && latest_version.whodunnit
    render 'show', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def update
    @client = Client.find(params[:id])
    @client.attributes = client_param
    Client.transaction do
      @approval = Approval.find_by(approved_type: 'Client', approved_id: @client.id) || create_approval
      file_update if params[:client][:files_attributes] && @approval.present?
      @client.save!
    end
    render_action_model_success_message(@client, :update)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@client, :update)
  end

  def statuses
    @statuses = t('enumerize.client.status')
    render json: @statuses, status: :ok
  end

  def update_approval
    @services ||= ApprovalUsers::UpdateStatusService.new(update_params: update_params, current_user: @current_user)
    if @services.execute
      update_status
      update_approval_notice
      update_execut_success
    else
      execut_fail
    end
  end

  def invalid_client
    @approval = Approval.find(params[:approval_id])
    @approval.status = 40
    @approval.save
    action_model_flash_success_message(@approval, :invalid)
    redirect_to client_list_path(params[:client_id])
  end

  def set_approval_user
    @approval_user = ApprovalUser.find_by(approval_id: params[:approval_id])
    @app= { name: @approval_user.user.name, status: @approval_user.status_text, comment: @approval_user.comment }
    render json: @app, status: :ok
  end

  def published_clients
    @clients = Client.all
    render json: @clients, status: :ok
  end

private

  def client_param
    params.require(:client).permit(
      :cd,
      :company_name,
      :department_name,
      :address,
      :zip_code,
      :phone_number,
      :memo,
      :is_valid,
      files_attributes: [:id, :file, :file_type, :legal_check, :_destroy],
    )
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
    redirect_to agreement_list_path('agreementClientList')
  end

  def execut_fail
    flash[:error] = I18n.t('action.update.fail', model: I18n.t('activerecord.models.approval'))
    redirect_to(:back)
  end

  def update_status
    @client = Client.find(params[:client_id])
    @client.status = 30 if params[:button] == 'permission'
    @client.save
  end

  def create_notice
    approval = Approval.find_by(approved_type: 'Client', approved_id: @client.id)
    user = approval.users.first
    ClientMailer.assignment_user(user: user, approval: approval).deliver_now
    Chatwork::Client.new(approval: approval, to_user: user).notify_assigned
  end

  def update_notice
    approval = @services.approval
    user = approval.users.first
    ClientMailer.update_client_approval(user: user, approval: approval).deliver_now
    Chatwork::Client.new(approval: approval, to_user: approval.users).notify_edit
  end

  def update_approval_notice
    approval = @services.approval
    if params[:button] == 'permission'
      if @client.status == 20
        ClientMailer.nda_permission_client_approval(user: approval.created_user, approval: approval).deliver_now
        Chatwork::Client.new(approval: approval, to_user: approval.created_user).notify_nda_permited
      elsif @client.status == 30
        ClientMailer.permission_client_approval(user: approval.created_user, approval: approval).deliver_now
        Chatwork::Client.new(approval: approval, to_user: approval.created_user).notify_permited
      end
    elsif params[:button] == 'disconfirm'
      ClientMailer.disconfirm_client_approval(user: approval.created_user, approval: approval).deliver_now
      Chatwork::Client.new(approval: approval, to_user: approval.created_user).notify_disconfirm
    end
  end

  def check_files
    db_file_type = @client.files.first.file_type
    uploading_file_type = params[:client][:files_attributes].first.second[:file_type]
    @client.status = if params[:client][:files_attributes].length == 2
                       10
                     elsif db_file_type == 'nda' || uploading_file_type == '10'
                       10
                     else
                       20
                     end
  end

  def create_approval
    approval_params = {
      name: Client.human_attribute_name(:approval_name, comany: @client.company_name),
      created_user_id: current_user.id,
      notes: @client.memo,
      category: 20,
      approved_id: @client.id,
      approved_type: "Client",
    }
    approval_user = User.find_by(is_chief: true)
    create_params = { user_id: approval_user.id } if approval_user.present?
    if Approvals::CreateApprovalService.new(approval_params: approval_params, create_params: create_params).execute
      Approval.find_by(approved_type: 'Client', approved_id: @client.id)
    else
      false
    end
  end

  def file_update
    @client.files.each do |file|
      return false if file.legal_check == false
    end
    @appr_params = { approval_id: @approval.id, button: 'pending', comment: '' }
    @services = ApprovalUsers::UpdateStatusService.new(update_params: @appr_params, current_user: User.find_by(is_chief: true))
    @services.execute
    check_files if @client.status == 20
    update_notice if @client.status == 10
  end
end
# rubocop:enable Metrics/ClassLength
