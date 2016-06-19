class Api::PartnersController < Api::ApiController
  def create
    @partner = Partner.new(partner_param)
    @partner.save!

    render_action_model_success_message(@partner, :create)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@partner, :create)
  end

private

  def partner_param
    params.require(:partner).permit(
      :name,
      :email,
      :company_name,
    )
  end
end
