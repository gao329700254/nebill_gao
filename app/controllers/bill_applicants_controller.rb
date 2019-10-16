class BillApplicantsController < ApplicationController
  # 申請者による、「申請」アクション
  def create
    @bill = Bill.find(params[:bill_id])

    @bill.pending_bill!
    @bill.bill_applicant.update!(comment: params[:comment])

    show_success_message(@bill, :apply, params[:bill_id])
  rescue ActiveRecord::RecordInvalid
    show_failure_message(:apply)
  end

  # 申請者による、「取り消し」アクション
  def update
    bill_id = params[:bill_applicant][:bill_id]
    @bill   = Bill.find(bill_id)

    @bill.cancelled_bill!

    show_success_message(@bill, :cancel, bill_id)
  rescue ActiveRecord::RecordInvalid
    show_failure_message(:cancel)
  end

private

  def show_success_message(model, action, params)
    flash[:success] = I18n.t("action.#{action}.success", model: I18n.t("activerecord.models.#{model.class.name.underscore}"))
    redirect_to bill_show_path(params)
  end

  def show_failure_message(action)
    flash[:error] = I18n.t("action.#{action}.fail", model: I18n.t('activerecord.models.bill'))
    redirect_to(:back)
  end
end
