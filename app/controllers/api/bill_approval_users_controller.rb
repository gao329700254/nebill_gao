class Api::BillApprovalUsersController < Api::ApiController
  def create
    @bill = Bill.find(params[:bill_id])
    @bill.approved_bill!

    @current_approver = @bill.bill_approval_users.where(user_id: @current_user.id).first
    @current_approver.update(status: 'approved', comment: params[:comment])

    show_success_message(@bill, :approve, params[:bill_id])
  rescue ActiveRecord::RecordInvalid
    show_failure_message(@bill, :approve)
  end

  def update
    bill_id = params[:bill_approval_user][:bill_id]
    @bill   = Bill.find(bill_id)
    @bill.sent_back_bill!

    @current_approver = @bill.bill_approval_users.where(user_id: @current_user.id)
    @current_approver.update(status: 'sent_back', comment: params[:bill_approval_user][:comment])

    @bill.bill_approval_users.each(&:sent_back_bill!)

    show_success_message(@bill, :send_back, bill_id)
  rescue ActiveRecord::RecordInvalid
    show_failure_message(@bill, :send_back)
  end

private

  def show_success_message(model, action, params)
    redirect_to bill_show_path(params)
    action_model_flash_success_message(model, action)
  end

  def show_failure_message(action)
    flash[:error] = I18n.t("action.#{action}.fail", model: I18n.t('activerecord.models.bill'))
    redirect_to(:back)
  end
end
