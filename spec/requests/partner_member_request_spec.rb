require 'rails_helper'

RSpec.describe 'partner members request' do
  let!(:user) { create(:user) }
  let!(:bill) { create(:bill) }
  let!(:partner) { create(:partner) }

  before { login(user) }

  describe 'DELETE /api/partner_members/:bill_id/:partner_id' do
    context 'with exist partner' do
      let!(:member) { create(:partner_member, bill: bill) }
      let(:path) { "/api/partner_members/#{bill.id}/#{member.partner.id}" }

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
      let(:path) { "/api/partner_members/#{bill.id}/#{partner.id}" }

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
      let(:path) { "/api/partner_members/#{bill.id}/0" }

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

  describe 'PATCH /api/partner_members/:bill_id/:partner_id' do
    context 'with exist bill' do
      let!(:member) { create(:partner_member, bill: bill) }
      let(:path) { "/api/partner_members/#{bill.id}/#{member.partner.id}" }

      context 'with correct parameter' do
        let(:params) do
          {
            members: {
              unit_price: 1,
              working_rate: 2,
              min_limit_time: 3,
              max_limit_time: 4,
              partner_attributes: {
                id: member.partner.id,
                name: 'name',
              },
            },
          }
        end

        it 'update the partner and return success code and message' do
          expect do
            patch path, params
          end.to change { member.reload && member.updated_at }

          expect(member.unit_price).to eq 1
          expect(member.working_rate).to eq 2
          expect(member.min_limit_time).to eq 3
          expect(member.max_limit_time).to eq 4
          expect(member.partner.id).to eq member.partner.id
          expect(member.partner.name).to eq 'name'

          expect(response).to be_success
          expect(response.status).to eq 201

          expect(json['id']).not_to eq nil
          expect(json['message']).to eq 'メンバーを更新しました'
        end
      end

      context 'with uncorrect parameter' do
        let(:params) do
          {
            members: {
              unit_price: 1,
              working_rate: 2,
              min_limit_time: 3,
              max_limit_time: 4,
              partner_attributes: {
                id: member.partner.id,
                name: '  ',
              },
            },
          }
        end

        it 'do not update the partner and return 422 Unprocessable Entity message' do
          expect do
            patch path, params
          end.not_to change { partner.reload && partner.updated_at }

          expect(response).not_to be_success
          expect(response.status).to eq 422

          expect(json['message']).to eq 'メンバーが更新できませんでした'
          expect(json['errors']['full_messages']).to eq ['名前を入力してください']
        end
      end
    end

    context 'with not exist bill id' do
      let!(:member) { create(:partner_member) }
      let(:path)    { "/api/partner_members/0/#{member.partner.id}" }

      it 'return 404 Not Found code and message' do
        patch path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end

    context 'with not exist member' do
      let(:path) { "/api/partner_members/#{bill.id}/#{partner.id}" }

      it 'return 404 Not Found code and message' do
        patch path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end

    context 'with not exist partner' do
      let(:path) { "/api/partner_members/#{bill.id}/0" }

      it 'return 404 Not Found code and message' do
        patch path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end
end
