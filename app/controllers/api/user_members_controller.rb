class Api::UserMembersController < Api::ApiController
  before_action :set_project_and_employee, only: [:create]
  before_action :set_member, only: [:update, :destroy]

  def create
    @member = @employee.create_user_member_in_nebill_and_sf!(@project, params[:partner])

    render_action_model_success_message(@member, :create)
  rescue ActiveRecord::RecordInvalid => e
    render_action_model_fail_message(e.record, :create)
  end

  def update
    @member.attributes = member_param
    @member.transaction do
      @member.save!
      @member.employee[:name] = params[:member][:name]
      @member.employee[:email] = params[:member][:email]
      @member.employee.save!
    end

    render_action_model_success_message(@member, :update)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@member, :update)
  end

  def destroy
    if @member.destroy
      @member.destroy_in_sf
      render_action_model_success_message(@member, :destroy)
    else
      render_action_model_fail_message(@member, :destroy)
    end
  end

private

  def set_project_and_employee
    @project = Project.find(params[:project_id])
    @employee = Employee.find(params[:user_id])
  end

  def set_member
    @member = Member.find(params[:user_id])
  end

  def member_param
    params.require(:member).permit(
      :working_period_start,
      :working_period_end,
      :man_month,
    )
  end
end
