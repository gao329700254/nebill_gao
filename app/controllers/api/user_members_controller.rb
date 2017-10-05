class Api::UserMembersController < Api::ApiController
  before_action :set_bill, only: [:create]
  before_action :set_user   , only: [:create, :destroy]

  def create
    @member = @user.join!(@bill)

    render_action_model_success_message(@member, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@member, :create)
  end

  def destroy
    @member = @user.members.find_by!(bill: params[:bill_id])

    if @member.destroy
      render_action_model_success_message(@member, :destroy)
    else
      render_action_model_fail_message(@member, :destroy)
    end
  end

private

  def set_bill
    @bill = Bill.find(params[:bill_id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
