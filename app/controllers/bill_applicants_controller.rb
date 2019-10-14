class BillApplicantsController < ApplicationController
  # 申請者による、「申請」アクション
  # 申請時に承認者を設定する
  def create
    @bill = Bill.find(params[:bill_id])

    ActiveRecord::Base.transaction do
      @bill.pending_bill!
      @bill.bill_applicant.update!(comment: params[:comment])

      create_bill_approval_users!

      show_success_message(@bill, :apply, params[:bill_id])
    rescue ActiveRecord::RecordInvalid
      show_failure_message(:apply)
    end
  end

  # 申請者による、「取消」アクション
  # 取消した時、未申請時と同じように、修正・承認者選択ができるようにする
  # 申請時に改めて承認者を選び直すため、取消時に設定済みの承認者を削除する
  def update
    bill_id = params[:bill_applicant][:bill_id]
    @bill   = Bill.find(bill_id)

    ActiveRecord::Base.transaction do
      @bill.cancelled_bill!
      @bill.bill_approval_users.destroy_all

      show_success_message(@bill, :cancel, bill_id)
    rescue ActiveRecord::RecordInvalid
      show_failure_message(:cancel)
    end
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

  def show_success_message(model, action, params)
    flash[:success] = I18n.t("action.#{action}.success", model: I18n.t("activerecord.models.#{model.class.name.underscore}"))
    redirect_to bill_show_path(params)
  end

  def show_failure_message(action)
    flash[:error] = I18n.t("action.#{action}.fail", model: I18n.t('activerecord.models.bill'))
    redirect_to(:back)
  end
end
