class Api::ApprovalUsersController < Api::ApiController
  before_action :the_value_present?, only: [:create]

  def create
    @services ||= ApprovalUsers::AddApprovalUserService.new(create_params: create_params, current_user: @current_user)
    if @services.execute
      create_notice
      create_execut_success
    else
      execut_fail
    end
  end

  def update
    @services ||= ApprovalUsers::UpdateStatusService.new(update_params: update_params, current_user: @current_user)
    if @services.execute
      update_notice
      update_execut_success
    else
      execut_fail
    end
  end

private

  def create_params
    params.permit(
      :approval_id,
      user: [:id],
    )
  end

  def update_params
    params.permit(
      :approval_id,
      :button,
      :comment,
    )
  end

  def user_param
    params.require(:user).permit(:id)
  end

  def the_value_present?
    unless user_param[:id].present? && User.find(user_param[:id]).name.present?
      flash[:error] = I18n.t("action.reassignment.fail")
      redirect_to approval_show_path(params[:approval_id])
      return
    end
  end

  def create_execut_success
    redirect_to approval_show_path(params[:approval_id])
    model_flash_success_message(:reassignment)
  end

  def update_execut_success
    action_model_flash_success_message(Approval.new, params[:button])
    redirect_to approval_list_path
  end

  def execut_fail
    flash[:error] = I18n.t('action.update.fail', model: I18n.t('activerecord.models.approval'))
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
    if params[:button] == 'permission'
      ApprovalMailer.permission_approval(user: approval.created_user, approval: approval).deliver_now
      Chatwork::Approval.new(approval: approval, to_user: approval.created_user).notify_permited
    elsif params[:button] == 'disconfirm'
      ApprovalMailer.disconfirm_approval(user: approval.created_user, approval: approval).deliver_now
      Chatwork::Approval.new(approval: approval, to_user: approval.created_user).notify_disconfirm
    end
  end

  def find_user
    @services.approval.users.find { |u| u.id == user_param[:id].to_i }
  end
end
