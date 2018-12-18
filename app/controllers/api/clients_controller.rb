class Api::ClientsController < Api::ApiController
  before_action :set_client, only: [:show, :update]
  def index
    @clients = Client.all.includes(:approvals).where.not(approvals: { status: 40 })

    render json: @clients, status: :ok
  end

  def create
    @client = Client.new(client_param)
    if @client.valid?
      Client.transaction do
        @client.save!
      end
      render_action_model_success_message(@client, :create)
    else
      render_action_model_fail_message(@client, :create)
    end
  rescue
    render_action_model_fail_message(@client, :create)
  end

  def show
    latest_version = Version.where(item_type: 'Client', item_id: @client.id).order(:created_at).last
    @user = User.find(latest_version.whodunnit) if latest_version && latest_version.whodunnit
    render 'show', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def update
    @client.attributes = client_param
    if params[:client][:files_attributes]
      @appr_params = { approval_id: params[:approval_id], button: 'pending', comment: '' }
      ApprovalUsers::UpdateStatusService.new(update_params: @appr_params, current_user: User.find(6)).execute
      @client.status = 10
    end
    @client.save!

    render_action_model_success_message(@client, :update)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@client, :update)
  end

  def statuses
    @statuses = t('enumerize.client.status')
    render json: @statuses, status: :ok
  end

  def update_approval
    if ApprovalUsers::UpdateStatusService.new(update_params: update_params, current_user: @current_user).execute
      update_status
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

private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_param
    params.require(:client).permit(
      :cd,
      :company_name,
      :department_name,
      :address,
      :zip_code,
      :phone_number,
      :memo,
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
    redirect_to client_list_path
  end

  def execut_fail
    flash[:error] = I18n.t('action.update.fail', model: I18n.t('activerecord.models.approval'))
    redirect_to(:back)
  end

  def update_status
    @client = Client.find(params[:client_id])
    @client.files.each do |file|
      @client.status = 20 if file.file_type == 10 && params[:button] == 'permission'
      @client.status = 30 if file.file_type == 20 && params[:button] == 'permission'
    end
    @client.save
  end
end
