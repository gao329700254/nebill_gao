class Api::BillApplicantsController < Api::ApiController
  # 申請者による、「申請」アクション
  def create
    @bill = Bill.find(params[:bill_id])

    @bill.pending_bill!
    @bill.bill_applicant.update!(comment: params[:comment])

    show_success_message(@bill, :apply, params[:bill_id])
  rescue ActiveRecord::RecordInvalid
    show_failure_message(@bill, :apply)
  end

  # 申請者による、「取り消し」アクション
  def update
    bill_id = params[:bill_applicant][:bill_id]
    @bill   = Bill.find(bill_id)

    @bill.cancelled_bill!

    show_success_message(@bill, :cancel, bill_id)
  rescue ActiveRecord::RecordInvalid
    show_failure_message(@bill, :cancel)
  end
end
