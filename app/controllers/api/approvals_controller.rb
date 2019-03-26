class Api::ApprovalsController < Api::ApiController
  before_action :the_value_present?, only: [:create]
  before_action :confirm_status, only: [:update]

  def create
    @services ||= Approvals::CreateApprovalService.new(approval_params: approval_params, create_params: create_params)
    if @services.execute
      create_notice
      create_execut_success
    else
      create_execut_fail
    end
  end

  def update
    @services ||= Approvals::UpdateApprovalService.new(approval_params: approval_params, update_params: update_params)
    if @services.execute
      update_notice
      update_execut_success
    else
      update_execut_fail
    end
  end

  def invalid
    @approval = Approval.find(params[:approval_id])
    @approval.status = 40
    @approval.save
    action_model_flash_success_message(@approval, :invalid)
    redirect_to approval_show_path(params[:approval_id])
  end

private

  def approval_params
    params.require(:approval).permit(
      :name,
      :category,
      :notes,
      :status,
      :created_user_id,
      files_attributes: [:id, :file, :original_filename, :_destroy],
    )
  end

  def create_params
    params.permit(
      :user_id,
    )
  end

  def update_params
    params.permit(
      :id,
    )
  end

  def the_value_present?
    unless @current_user.default_allower.present?
      redirect_to approval_new_path, flash: { error:  I18n.t("errors.messages.default_allower_is_nill") }
      return
    end
    return if params[:user_id].present?
    redirect_to approval_new_path, flash: { error:  I18n.t("errors.messages.default_allower_is_empty") }
  end

  def confirm_status
    unless Approval.find(params[:id]).status == 30
      flash[:error] = I18n.t("action.update.fail", model: I18n.t("activerecord.models.approval"))
      redirect_to approval_show_path(params[:id])
      return
    end
  end

  def create_execut_success
    action_model_flash_success_message(@services.approval, :create)
    redirect_to approval_show_path(approval_id: @services.approval.id)
  end

  def create_execut_fail
    flash[:error] = "#{I18n.t('action.create.fail', model: I18n.t('activerecord.models.approval'))}"\
                              " \n #{@services.approval.errors.full_messages.join('<br>')}"
    redirect_to approval_new_path
  end

  def update_execut_success
    action_model_flash_success_message(Approval.new, :update)
    redirect_to approval_show_path(params[:id])
  end

  def update_execut_fail
    flash[:error] = "#{I18n.t('action.update.fail', model: I18n.t('activerecord.models.approval'))}"\
                              " \n #{@services.approval.errors.full_messages.join('<br>')}"
    redirect_to(:back)
  end

  def create_notice
    approval = @services.approval
    user = find_user
    ApprovalMailer.assignment_user(user: user, approval: approval).deliver_now
    Chatwork::Approval.new(approval: approval, to_user: user).notify_assigned
  end

  def update_notice
    approval = @services.approval
    approval.users.each do |user|
      ApprovalMailer.update_approval(user: user, approval: approval).deliver_now
    end
    Chatwork::Approval.new(approval: approval, to_user: approval.users).notify_edit
  end

  def find_user
    @services.approval.users.find { |u| u.id == params[:user_id].to_i }
  end
end
