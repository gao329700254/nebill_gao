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

  describe 'DELETE /api/user_members/:project_id/:user_id' do
    context 'with exist user' do
      let(:project) { create(:project) }
      let!(:member) { create(:user_member, project: project) }
      let(:path) { "/api/user_members/#{project.id}/#{member.user.id}" }

      it 'delete the user_member and return success message' do
        expect do
          delete path
        end.to change(Member, :count).by(-1)

        expect(response).to be_success
        expect(response.status).to eq 201

        expect(json['message']).to eq 'メンバーを削除しました'
      end
    end

    context 'with not exist user_member' do
      let(:project) { create(:project) }
      let(:path) { "/api/user_members/#{project.id}/0" }

      it 'return 404 Not Found code and message' do
        expect do
          delete path
        end.not_to change(Member, :count)

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end
end
