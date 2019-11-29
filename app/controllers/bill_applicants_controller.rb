class BillApplicantsController < ApplicationController
  # 申請者による、「申請」アクション
  # 申請時に申請者、承認者を設定する
  def create
    @bill = Bill.find(params[:bill_id])
    @bill.make_bill_application!(@current_user.id, params[:comment], params[:user_id], params[:reapply])

    show_success_message(:apply, params[:bill_id])
  rescue ActiveRecord::RecordInvalid
    show_failure_message(:apply)
  end

  # 申請者による、「取消」アクション
  # 取消した時、未申請時と同じように、修正・承認者選択ができるようにする
  # 申請時に改めて承認者を選び直すため、取消時に設定済みの承認者を削除する
  def update
    @bill = Bill.find(params[:bill_id])
    @bill.cancel_bill_application!

    show_success_message(:cancel, params[:bill_id])
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
