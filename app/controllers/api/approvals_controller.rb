class Api::ApprovalsController < Api::ApiController
  before_action :the_value_present?, only: [:create]

  def create
    @approval = Approval.new(approval_params)

    if @approval.save
      create_notice
      create_execut_success
    else
      create_execut_fail
    end
  end

  def update
    @approval = Approval.find(params[:id])

    # HACK: https://cuonlab.backlog.jp/view/NEBILL-259
    # 稟議が稟議グループ指定の場合では、@approval.approval_usersが空なので、すぐ下のeach文は現時点で意味がない
    @approval.approval_users.each do |approval_user|
      approval_user.status = :pending if approval_user.status == :disconfirm
    end

    if @approval.update(approval_params)
      update_notice
      update_execut_success
    else
      update_execut_fail
    end
  end

  def invalid
    @approval = Approval.find(params[:approval_id])
    # HACK: https://cuonlab.backlog.jp/view/NEBILL-259
    ApprovalIndividualGroupSwitch.new(@approval, current_user)

    @approval.status = :invalid
    @approval.invalidate_approval_users
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
      :approvaler_type,
      approval_approval_group_attributes: [:id, :approval_group_id, :_destroy],
      approval_users_attributes: [:id, :user_id, :status, :comment, :_destroy],
      files_attributes: [:id, :file, :original_filename, :_destroy],
    )
  end

  def the_value_present?
    unless @current_user.default_allower.present?
      redirect_to approval_new_path, flash: { error:  I18n.t("errors.messages.default_allower_is_nill") }
      return
    end
  end

  def create_execut_success
    action_model_flash_success_message(@approval, :create)
    redirect_to approval_show_path(approval_id: @approval.id)
  end

  def create_execut_fail
    flash[:error] = "#{I18n.t('action.create.fail', model: I18n.t('activerecord.models.approval'))}"\
                              " \n #{@approval.errors.full_messages.join('<br>')}"
    redirect_to approval_new_path
  end

  def update_execut_success
    action_model_flash_success_message(Approval.new, :update)
    redirect_to approval_show_path(params[:id])
  end

  def update_execut_fail
    flash[:error] = "#{I18n.t('action.update.fail', model: I18n.t('activerecord.models.approval'))}"\
                              " \n #{@approval.errors.full_messages.join('<br>')}"
    redirect_to(:back)
  end

  def create_notice
    @approval.users.each do |user|
      ApprovalMailer.assignment_user(user: user, approval: @approval).deliver_now
      Chatwork::Approval.new(approval: @approval, to_user: user).notify_assigned
    end
  end

  def update_notice
    @approval.users.each do |user|
      ApprovalMailer.update_approval(user: user, approval: @approval).deliver_now
    end
    Chatwork::Approval.new(approval: @approval, to_user: @approval.users).notify_edit
  end
end
