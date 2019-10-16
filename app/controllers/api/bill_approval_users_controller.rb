class Api::BillApprovalUsersController < Api::ApiController
  # 承認者による「承認」アクション
  def create
    @bill             = Bill.find(params[:bill_id])
    @current_approver = @bill.bill_approval_users.where(user_id: @current_user.id).first

    ActiveRecord::Base.transaction do
      # 二段目承認者が承認＝承認者全員が承認したときに、請求のステータスを「承認済み」に更新する
      @bill.approved_bill! if @current_approver.secondary_role?
      @current_approver.update!(status: 'approved', comment: params[:comment])

      show_success_message(params[:bill_id], @bill, :approve)
    rescue ActiveRecord::RecordInvalid
      show_failure_message(:approve)
    end
  end

  # 承認者による「差戻」アクション
  # 差し戻された時、全承認者のステータスを「差戻」にする
  # 差し戻したユーザについては、コメント付きで更新する
  def update
    bill_id           = params[:bill_approval_user][:bill_id]
    @bill             = Bill.find(bill_id)
    @current_approver = @bill.bill_approval_users.find_by(user_id: @current_user.id)

    ActiveRecord::Base.transaction do
      @bill.sent_back_bill!
      @current_approver.update!(status: 'sent_back', comment: params[:bill_approval_user][:comment])
      @bill.bill_approval_users.each(&:sent_back_bill!)

      show_success_message(bill_id, @bill, :send_back)
    rescue ActiveRecord::RecordInvalid
      show_failure_message(:send_back)
    end
  end

private

  def show_success_message(params, model, action)
    redirect_to bill_show_path(params)
    action_model_flash_success_message(model, action)
  end

  def show_failure_message(action)
    flash[:error] = I18n.t("action.#{action}.fail", model: I18n.t('activerecord.models.bill'))
    redirect_to(:back)
  end
end
