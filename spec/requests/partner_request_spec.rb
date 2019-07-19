require 'rails_helper'

RSpec.describe 'partner request' do
  let!(:user) { create(:user) }

  before { login(user) }

  describe 'GET /api/partners' do
    let!(:partner1) { create(:partner) }
    let!(:partner2) { create(:partner) }
    let!(:partner3) { create(:partner) }
    let(:path) { '/api/partners' }

    it 'return a list of partners' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 3

      expect(json[0]['id']).to           eq partner1.id
      expect(json[0]['name']).to         eq partner1.name
      expect(json[0]['email']).to        eq partner1.email
      expect(json[0]['company_name']).to eq partner1.company_name
      expect(json[0]['created_at']).to   eq partner1.created_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
      expect(json[0]['updated_at']).to   eq partner1.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
    end
  end

  describe 'GET /api/projects/:project_id/partners' do
    context 'with exist projects id' do
      let(:project) { create(:project) }
      let!(:partner1) { create(:partner, :with_project, project: project) }
      let!(:partner2) { create(:partner, :with_project, project: project) }
      let!(:partner3) { create(:partner, :with_project, project: project) }
      let!(:partner4) { create(:partner, :with_project) }
      let(:path) { "/api/projects/#{project.id}/partners" }

      it 'return a list of project_partners' do
        get path

        expect(response).to be_success
        expect(response.status).to eq 200
        expect(json.count).to eq 3

        json.sort_by! { |x| x['id'].to_i }

        expect(json[0]['id']).to                       eq partner1.id
        expect(json[0]['name']).to                     eq partner1.name
        expect(json[0]['member']['unit_price']).to     eq partner1.members[0].unit_price
        expect(json[0]['member']['min_limit_time']).to eq partner1.members[0].min_limit_time
        expect(json[0]['member']['max_limit_time']).to eq partner1.members[0].max_limit_time
        expect(json[0]['member']['working_rate']).to   eq partner1.members[0].working_rate
        expect(json[0]['created_at']).to               eq partner1.created_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
        expect(json[0]['updated_at']).to               eq partner1.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")

        expect(json[1]['id']).to                       eq partner2.id
        expect(json[1]['name']).to                     eq partner2.name
        expect(json[1]['member']['unit_price']).to     eq partner2.members[0].unit_price
        expect(json[1]['member']['min_limit_time']).to eq partner2.members[0].min_limit_time
        expect(json[1]['member']['max_limit_time']).to eq partner2.members[0].max_limit_time
        expect(json[1]['member']['working_rate']).to   eq partner2.members[0].working_rate
        expect(json[1]['created_at']).to               eq partner2.created_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
        expect(json[1]['updated_at']).to               eq partner2.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")

        expect(json[2]['id']).to                       eq partner3.id
        expect(json[2]['name']).to                     eq partner3.name
        expect(json[2]['member']['unit_price']).to     eq partner3.members[0].unit_price
        expect(json[2]['member']['min_limit_time']).to eq partner3.members[0].min_limit_time
        expect(json[2]['member']['max_limit_time']).to eq partner3.members[0].max_limit_time
        expect(json[2]['member']['working_rate']).to   eq partner3.members[0].working_rate
        expect(json[2]['created_at']).to               eq partner3.created_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
        expect(json[2]['updated_at']).to               eq partner3.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
      end
    end

    context 'with not exist bill id' do
      let(:path) { '/api/projects/0/partners' }

      it 'return 404 Not Found code and message' do
        get path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end

  describe 'GET /api/projects/:project_id/partners' do
    context 'with exist project id' do
      let(:project) { create(:contracted_project) }
      let!(:partner1) { create(:partner, :with_project, project: project) }
      let!(:partner2) { create(:partner, :with_project, project: project) }
      let!(:partner3) { create(:partner, :with_project, project: project) }
      let!(:partner4) { create(:partner_member, project: project, partner: partner3) }
      let(:path) { "/api/projects/#{project.id}/partners" }

      it 'return a list of partners' do
        get path

        expect(response).to be_success
        expect(response.status).to eq 200
        expect(json.count).to eq 3

        json.sort_by! { |x| x['id'].to_i }

        expect(json[0]['id']).to           eq partner1.id
        expect(json[0]['name']).to         eq partner1.name
        expect(json[0]['email']).to        eq partner1.email
        expect(json[0]['company_name']).to eq partner1.company_name
        expect(json[0]['created_at']).to   eq partner1.created_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
        expect(json[0]['updated_at']).to   eq partner1.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")

        expect(json[1]['id']).to           eq partner2.id
        expect(json[1]['name']).to         eq partner2.name
        expect(json[1]['email']).to        eq partner2.email
        expect(json[1]['company_name']).to eq partner2.company_name
        expect(json[1]['created_at']).to   eq partner2.created_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
        expect(json[1]['updated_at']).to   eq partner2.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")

        expect(json[2]['id']).to           eq partner3.id
        expect(json[2]['name']).to         eq partner3.name
        expect(json[2]['email']).to        eq partner3.email
        expect(json[2]['company_name']).to eq partner3.company_name
        expect(json[2]['created_at']).to   eq partner3.created_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
        expect(json[2]['updated_at']).to   eq partner3.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
      end
    end

    context 'with not exist project id' do
      let(:path) { '/api/projects/0/partners' }

      it 'return 404 Not Found code and message' do
        get path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end

  describe 'PATCH /api/partners/:partner_id' do
    context 'with exist partner' do
      let!(:partner) { create(:partner) }
      let(:path) { "/api/partners/#{partner.id}" }

      context 'with correct parameter' do
        let(:params) do
          {
            partner: {
              id:    partner.id,
              name: 'name',
              email: 'sample@sample.com',
              company_name: 'company_name',
            },
          }
        end

        it 'update the partner and return success code and message' do
          expect do
            patch path, params: params
          end.to change { partner.reload && partner.updated_at }

          expect(partner.id).to eq partner.id
          expect(partner.name).to eq 'name'
          expect(partner.email).to eq 'sample@sample.com'
          expect(partner.company_name).to eq 'company_name'

          expect(response).to be_success
          expect(response.status).to eq 201

          expect(json['id']).not_to eq nil
          expect(json['message']).to eq 'パートナーを更新しました'
        end
      end

      context 'with uncorrect parameter' do
        let(:params) do
          {
            partner: {
              id:    partner.id,
              name: '  ',
              email: 'sample@sample.com',
              company_name: 'company_name',
            },
          }
        end

        it 'do not update the partner and return 422 Unprocessable Entity message' do
          expect do
            patch path, params: params
          end.not_to change { partner.reload && partner.updated_at }

          expect(response).not_to be_success
          expect(response.status).to eq 422

          expect(json['message']).to eq 'パートナーが更新できませんでした'
          expect(json['errors']['full_messages']).to eq ['名前を入力してください']
        end
      end
    end

    context 'with not exist partner id' do
      let(:path)    { "/api/partners/0" }

      it 'return 404 Not Found code and message' do
        patch path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end
end
