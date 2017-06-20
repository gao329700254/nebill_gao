class Api::PartnerMembersController < Api::ApiController
  before_action :set_project, only: [:create]
  before_action :set_partner, only: [:create, :destroy, :update]
  before_action :set_member,  only: [:update, :destroy]

  def create
    @member = @partner.join!(
      @project, params[:member][:unit_price],
      params[:member][:working_rate],
      params[:member][:min_limit_time],
      params[:member][:max_limit_time]
    )

    render_action_model_success_message(@member, :create)
  rescue ActiveRecord::RecordInvalid => e
    render_action_model_fail_message(e.record, :create)
  end

  def update
    @member.attributes = member_param
    @member.save!

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

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_partner
    @partner = Partner.find(params[:partner_id])
  end

  def set_member
    @member= @partner.members.find_by!(project: params[:project_id])
  end

  def member_param
    params.require(:members).permit(
      :unit_price,
      :working_rate,
      :min_limit_time,
      :max_limit_time,
      partner_attributes: [
        :id,
        :name,
        :email,
        :company_name,
      ],
    )
  end
end
