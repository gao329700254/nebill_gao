require 'rails_helper'

RSpec.describe 'user members request' do
  let!(:user) { create(:user) }
  let!(:project) { create(:contracted_project) }
  let!(:bill) { create(:bill) }

  before { login(user) }

  describe 'POST /api/user_members/:project_id/:user_id' do
    let(:path) { "/api/user_members/#{project.id}/#{user.employee.id}" }

    let(:params) do
      {
        partner: {
          man_month: 1,
        },
      }
    end

    it 'create a user member' do
      expect do
        post path, params: params
      end.to change(Member, :count).by(1)

      expect(project.users).to include user
    end
  end

  describe 'DELETE /api/user_members/:project_id/:user_id' do
    context 'with exist user' do
      let!(:member) { create(:user_member, project: project) }
      let(:path) { "/api/user_members/#{project.id}/#{member.id}" }

      it 'delete the user_member and return success message' do
        expect do
          delete path
        end.to change(Member, :count).by(-1)

        expect(response).to be_success
        expect(response.status).to eq 201

        expect(json['message']).to eq 'メンバーを削除しました'
      end
    end

    context 'with not exist bill' do
      let!(:member) { create(:user_member) }
      let(:path) { "/api/user_members/0/#{member.user.id}" }

      it 'return 404 Not Found code and message' do
        expect do
          delete path
        end.not_to change(Member, :count)

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end

    context 'with not exist member' do
      let(:path) { "/api/user_members/#{project.id}/#{user.id}" }

      it "return 404 Not Found code and message" do
        expect do
          delete path
        end.not_to change(Member, :count)

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end

    context 'with not exist user_member' do
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
