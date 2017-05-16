require 'rails_helper'

RSpec.describe 'partner members request' do
  let!(:user) { create(:user) }

  before { login(user) }

  describe 'POST /api/partner_members/:project_id/:partner_id' do
    let(:project) { create(:project) }
    let(:partner) { create(:partner) }
    let(:path) { "/api/partner_members/#{project.id}/#{partner.id}" }

    let(:params) do
      {
        member: {
          unit_price: 1,
          working_rate: 0.6,
          min_limit_time: 1,
          max_limit_time: 2,
        },
      }
    end

    it 'create a partner member' do
      expect do
        post path, params
      end.to change(Member, :count).by(1)

      expect(project.partners).to include partner
    end
  end
end
