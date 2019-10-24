class BillApplicantsController < ApplicationController
  # 申請者による、「申請」アクション
  # 申請時に承認者を設定する
  def create
    @bill = Bill.find(params[:bill_id])

    ActiveRecord::Base.transaction do
      @bill.update_bill_and_applicant!(params[:comment])

      if params[:reapply].present?
        @bill.recreate_bill_approval_users!(params[:user_id])
      else
        @bill.create_bill_approval_users!(params[:user_id])
      end

      show_success_message(:apply, params[:bill_id])
    end
  rescue ActiveRecord::RecordInvalid
    show_failure_message(:apply)
  end

  # 申請者による、「取消」アクション
  # 取消した時、未申請時と同じように、修正・承認者選択ができるようにする
  # 申請時に改めて承認者を選び直すため、取消時に設定済みの承認者を削除する
  def update
    bill_id = params[:bill_applicant][:bill_id]
    @bill   = Bill.find(bill_id)

    ActiveRecord::Base.transaction do
      @bill.cancel_apply!
      show_success_message(:cancel, bill_id)
    end
  rescue ActiveRecord::RecordInvalid
    show_failure_message(:cancel)
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
