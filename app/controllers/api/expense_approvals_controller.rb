class Api::ExpenseApprovalsController < Api::ApiController
  def index
    @expense_approvals = ExpenseApproval.search_expense_approval(current_user: current_user, search_created_at: params[:created_at])
    render 'index', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def update
    @expense_approval = ExpenseApproval.find(params[:id])
    if @expense_approval.status == 40
      flash[:error] = I18n.t("errors.messages.wrong_status")
      redirect_to expense_approval_show_path(params[:id]) && return
    end
    @current_user_approval = @expense_approval.expense_approval_user.includes(:user).find_by(user_id: @current_user.id)
    update_button_type
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "#{I18n.t('action.update.fail', model: I18n.t('activerecord.models.expense_approval'))}"\
                    " \n #{@expense_approval.errors.full_messages.join('<br>')}"

    redirect_to(:back)
  end

  def edit
    if @expense_approval.status != 30
      flash[:error] = I18n.t("action.update.fail", model: I18n.t("activerecord.models.expense_approval"))
      redirect_to expense_approval_show_path(params[:id])
      return
    end
    @expense_approval.update(params)

    if @expense_approval.update!(status: 10)
      @expense_approval.users.each do |user|
        ExpenseApprovalMailer.update_expense_approval(user: user, expense_approval: @expense_approval).deliver_now
        Chatwork::ExpenseApproval.new(approval: @expense_approval, to_user: @expense_approval.created_user).notify_edit
      end
      action_model_flash_success_message(@expense_approval, :update)
    end

    redirect_to expense_approval_show_path(params[:id])
  end

private

  def update_button_type
    case params[:button]
    when 'invalid'
      invalid
    when 'permission'
      permission
    when 'disconfirm'
      disconfirm
    when 'reassignment'
      reassignment
    when 'edit'
      edit
    end
  end

  def invalid
    @expense_approval.status = :invalid
    @expense_approval.invalidate_approval_users
    @expense_approval.save
    action_model_flash_success_message(@expense_approval, :invalid)
    redirect_to expense_approval_show_path(params[:id])
  end

  def reassignment
    if !params[:user][:id].empty?
      @expense_approval_user = @expense_approval.expense_approval_user.build(user_id: params[:user][:id])
      current_user_approval_update
    else
      flash[:error] = I18n.t("action.reassignment.fail")
    end
    redirect_to expense_approval_show_path(params[:id])
  end

  def permission
    @current_user_approval.update!(status: 20, comment: params[:expense_approval_user][:comment])

    @expense_approval_users = @expense_approval.expense_approval_user.includes(:user)

    if @expense_approval_users.any? { |expense_approval_user| expense_approval_user.status == 20 }
      @expense_approval.update!(status: 20)
      ExpenseApprovalMailer.permission_expense_approval(user: @expense_approval.created_user, expense_approval: @expense_approval).deliver_now
      Chatwork::ExpenseApproval.new(expense_approval: @expense_approval, to_user: @expense_approval.created_user).notify_permited
    elsif @expense_approval_users.none? { |expense_approval_user| expense_approval_user.status == 30 }
      @expense_approval.update!(status: 10)
    end

    action_model_flash_success_message(@expense_approval, :permission)
    redirect_to agreement_list_path('agreementExpenseApprovalList')
  end

  def disconfirm
    @current_user_approval.update!(status: 30, comment: params[:expense_approval_user][:comment])
    @expense_approval.update!(status: 30)
    ExpenseApprovalMailer.disconfirm_expense_approval(user: @expense_approval.created_user, expense_approval: @expense_approval).deliver_now
    Chatwork::ExpenseApproval.new(expense_approval: @expense_approval, to_user: @expense_approval.created_user).notify_disconfirm
    action_model_flash_success_message(@expense_approval, :disconfirm)
    redirect_to agreement_list_path('agreementExpenseApprovalList')
  end

  def current_user_approval_update
    if @expense_approval_user.user.name.present?
      if @current_user_approval.present?
        @current_user_approval.update!(status: 40)
      end
      @expense_approval_user.save!
      @expense_approval.status == 20 && @expense_approval.update!(status: 10)
      ExpenseApprovalMailer.assignment_user(user: @expense_approval_user.user, expense_approval: @expense_approval).deliver_now

      model_flash_success_message(:reassignment)
    else
      flash[:error] = I18n.t("action.reassignment.fail")
    end
  end
end
