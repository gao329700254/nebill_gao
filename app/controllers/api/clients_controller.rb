class Api::ClientsController < Api::ApiController
  before_action :set_client, only: [:show, :update]

  def index
    @clients = Client.all

    render json: @clients, status: :ok
  end

  def create
    @client = Client.new(client_param)
    @client.save!

    render_action_model_success_message(@client, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@client, :create)
  end

  def show
    render json: @client, status: :ok
  end

  def update
    @client.attributes = client_param
    @client.save!

    render_action_model_success_message(@client, :update)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@client, :update)
  end

private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_param
    params.require(:client).permit(
      :cd,
      :company_name,
      :department_name,
      :address,
      :zip_code,
      :phone_number,
      :memo,
    )
  end
end
