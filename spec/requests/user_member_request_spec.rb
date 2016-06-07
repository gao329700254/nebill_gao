require 'rails_helper'

RSpec.describe 'user members request' do
  let!(:user) { create(:user) }

  before { login(user) }

  describe 'POST /api/user_members/:project_id/:user_id' do
    let(:project) { create(:project) }
    let(:path) { "/api/user_members/#{project.id}/#{user.id}" }

    it 'create a user member' do
      expect do
        post path
      end.to change(Member, :count).by(1)

      expect(project.users).to include user
    end
  end
end
