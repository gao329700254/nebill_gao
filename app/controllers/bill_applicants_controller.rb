class BillApplicantsController < ApplicationController
  # 申請者による、「申請」アクション
  def create
    @bill = Bill.find(params[:bill_id])

    @bill.pending_bill!
    @bill.bill_applicant.update!(comment: params[:comment])

    create_bill_approval_users!

    show_success_message(@bill, :apply, params[:bill_id])
  rescue ActiveRecord::RecordInvalid
    show_failure_message(:apply)
  end

  # 申請者による、「取り消し」アクション
  def update
    bill_id = params[:bill_applicant][:bill_id]
    @bill   = Bill.find(bill_id)

    @bill.cancelled_bill!
    @bill.bill_approval_users.destroy_all

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

private

  def create_bill_approval_users!
    @bill.bill_approval_users.destroy_all if params[:reapply].present?

    # 申請時に選択されたユーザを一段目承認者として作成する
    @bill.bill_approval_users.create!(role: 'primary', status: 'pending', user_id: params[:user_id])
    # 「社長フラグ(= is_chief)」を有するユーザを二段目承認者として作成する
    chief = User.find_by(is_chief: true)
    @bill.bill_approval_users.create!(role: 'secondary', status: 'pending', user_id: chief.id)
  end
end
