class Api::BillDetailsController < Api::ApiController
  def create
    bill = Bill.find(params[:bill_id])
    bill.recreate_all_details!(params[:details].values, params[:expense].to_i)

    render_action_model_success_message(bill, :update)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(bill, :update)
  end
end
