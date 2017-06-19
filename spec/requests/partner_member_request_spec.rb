require 'rails_helper'

RSpec.describe 'partner members request' do
  let!(:user) { create(:user) }
  let!(:project) { create(:project) }
  let!(:partner) { create(:partner) }

  before { login(user) }

  describe 'POST /api/partner_members/:project_id/:partner_id' do
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

  describe 'DELETE /api/partner_members/:project_id/:partner_id' do
    context 'with exist partner' do
      let!(:member) { create(:partner_member, project: project) }
      let(:path) { "/api/partner_members/#{project.id}/#{member.partner.id}" }

      it 'delete a partner_member and return the success message' do
        expect do
          delete path
        end.to change(Member, :count).by(-1)

        expect(response).to be_success
        expect(response.status).to eq 201

        expect(json['message']).to eq 'メンバーを削除しました'
      end
    end

    context 'with not exist project' do
      let!(:member) { create(:partner_member) }
      let(:path) { "/api/partner_members/0/#{member.partner.id}" }

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
      let(:path) { "/api/partner_members/#{project.id}/#{partner.id}" }

      it "return 404 Not Found code and message" do
        expect do
          delete path
        end.not_to change(Member, :count)

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end

    context 'with not exist partner' do
      let(:path) { "/api/partner_members/#{project.id}/0" }

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
