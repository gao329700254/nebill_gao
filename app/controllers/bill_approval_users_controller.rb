class BillApprovalUsersController < ApplicationController
  # 承認者による「承認」アクション
  def create
    @bill = Bill.find(params[:bill_id])
    @bill.approve_bill_application!(@current_user.id, params[:comment])

    show_success_message(:approve, params[:bill_id])
  rescue ActiveRecord::RecordInvalid
    show_failure_message(:approve)
  end

  # 承認者による「差戻」アクション
  # 差し戻された時、全承認者のステータスを「差戻」にする
  # 差し戻したユーザについては、コメント付きで更新する
  def update
    bill_id = params[:bill_approval_user][:bill_id]
    @bill   = Bill.find(bill_id)
    @bill.send_back_bill_application!(@current_user.id, params[:bill_approval_user][:comment])

    show_success_message(:send_back, bill_id)
  rescue ActiveRecord::RecordInvalid
    show_failure_message(:send_back)
  end

private

  def show_success_message(action, params)
    flash[:success] = I18n.t("action.#{action}.success", model: Bill.model_name.human)
    redirect_to bill_show_path(params)
  end

  def show_failure_message(action)
    flash[:error] = I18n.t("action.#{action}.fail", model: Bill.model_name.human)
    redirect_to(:back)
  end
end
