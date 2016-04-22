class Api::BillsController < Api::ApiController
  def index
    @bills = Bill.all

    render json: @bills, status: :ok
  end
end
