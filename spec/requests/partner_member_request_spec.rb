require 'rails_helper'

RSpec.describe 'partner members request' do
  let!(:user) { create(:user) }

  before { login(user) }

  describe 'POST /api/user_members/:project_id/:partner_id' do
    let(:project) { create(:project) }
    let(:partner) { create(:partner) }
    let(:path) { "/api/partner_members/#{project.id}/#{partner.id}" }

    it 'create a partner member' do
      expect do
        post path
      end.to change(Member, :count).by(1)

      expect(project.partners).to include partner
    end
  end
end
