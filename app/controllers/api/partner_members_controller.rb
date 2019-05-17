class Api::PartnerMembersController < Api::ApiController
  before_action :set_member, only: [:update, :destroy]

  def create
    @member = Member.new(member_param)
    @member.employee_id = params[:partner_id]
    @member.project_id = params[:project_id]
    @member.type = 'PartnerMember'
    @member.save!

    render_action_model_success_message(@member, :create)
  rescue ActiveRecord::RecordInvalid => e
    render_action_model_fail_message(e.record, :create)
  end

  def update
    @member.attributes = member_param
    @member.transaction do
      @member.save!
      @member.employee[:name] = params[:partner][:name]
      @member.employee[:email] = params[:partner][:email]
      @member.employee.save!
    end

    render_action_model_success_message(@member, :update)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@member, :update)
  end

  def destroy
    if @member.destroy
      render_action_model_success_message(@member, :destroy)
    else
      render_action_model_fail_message(@member, :destroy)
    end
  end

private

  def set_member
    @member = Member.includes(:employee).find(params[:partner_id])
  end

  def member_param
    params.require(:partner).permit(
      :unit_price,
      :working_rate,
      :min_limit_time,
      :max_limit_time,
      :working_period_start,
      :working_period_end,
    )
  end
end
