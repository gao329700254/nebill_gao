require 'rails_helper'

RSpec.describe 'clients request' do
  let!(:user) { create(:user) }

  before { login(user) }

  describe "GET /api/clients" do
    let!(:client1) { create(:client) }
    let!(:client2) { create(:client) }
    let!(:client3) { create(:client) }
    let!(:client4) { create(:client) }
    let(:path) { "/api/clients" }

    it 'return a list of clients' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 4

      json0 = json[0]
      expect(json0).to have_key 'id'
      expect(json0).to have_key 'cd'
      expect(json0).to have_key 'company_name'
      expect(json0).to have_key 'department_name'
      expect(json0).to have_key 'address'
      expect(json0).to have_key 'zip_code'
      expect(json0).to have_key 'phone_number'
      expect(json0).to have_key 'memo'
    end
  end

  describe 'GET /api/clients/:id' do
    context 'with exist client id' do
      let!(:client) { create(:client) }
      let(:path) { "/api/clients/#{client.id}" }

      it 'return the client' do
        get path

        expect(response).to be_success
        expect(response.status).to eq 200

        expect(json['id']).to               eq client.id
        expect(json['cd']).to               eq client.cd
        expect(json['company_name']).to     eq client.company_name
        expect(json['department_name']).to  eq client.department_name
        expect(json['address']).to          eq client.address
        expect(json['zip_code']).to         eq client.zip_code
        expect(json['phone_number']).to     eq client.phone_number
        expect(json['memo']).to             eq client.memo
        expect(json['created_at']).to       eq client.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
        expect(json['updated_at']).to       eq client.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      end

      context 'with not exist client id' do
        let(:path) { '/api/clients/0' }

        it 'return 404 Not Found code and message' do
          get path

          expect(response).not_to be_success
          expect(response.status).to eq 404

          expect(json['message']).to eq 'リソースが見つかりませんでした'
        end
      end
    end
  end

  describe 'POST /api/client' do
    let(:path) { "/api/clients" }

    context 'with correct parameter' do
      let(:params) do
        {
          client: {
            cd: 'CLIENT-1',
            company_name:     'company_name',
            department_name:  'department_name',
            zip_code:         '000-0000',
            phone_number:     '000-000-0000',
            memo:             'memo',
          },
        }
      end

      it 'create a client' do
        expect do
          post path, params
        end.to change(Client, :count).by(1)

        client = Client.first
        expect(client.cd).to               eq 'CLIENT-1'
        expect(client.company_name).to     eq 'company_name'
        expect(client.department_name).to  eq 'department_name'
        expect(client.zip_code).to         eq '000-0000'
        expect(client.phone_number).to     eq '000-000-0000'
        expect(client.memo).to             eq 'memo'
      end
    end

    context 'with uncorrect parameter' do
      let(:params) do
        {
          client: {
            cd: '  ',
            company_name:     'company_name',
            department_name:  'department_name',
            zip_code:         '000-0000',
            phone_number:     '000-000-0000',
            memo:             'memo',
          },
        }
      end

      it 'do not create a client' do
        expect do
          post path, params
        end.not_to change(Client, :count)
      end
    end
  end

  describe 'PATCH /api/clients/:id' do
    context 'with exist client id' do
      let(:client) { create(:client) }
      let(:path)   { "/api/clients/#{client.id}" }

      context 'with correct values' do
        let(:params) do
          {
            client: {
              cd: 'CLIENT-1',
              company_name:     'company_name',
              department_name:  'department_name',
              zip_code:         '000-0000',
              phone_number:     '00-0000-0000',
              memo:             'memo',
            },
          }
        end

        it 'update the client' do
          expect do
            patch path, params
          end.to change { client.reload && client.updated_at }

          expect(client.cd).to               eq 'CLIENT-1'
          expect(client.company_name).to     eq 'company_name'
          expect(client.department_name).to  eq 'department_name'
          expect(client.zip_code).to         eq '000-0000'
          expect(client.phone_number).to     eq '00-0000-0000'
          expect(client.memo).to             eq 'memo'
        end

        it 'return success code and message' do
          patch path, params

          expect(response).to be_success
          expect(response.status).to eq 201

          expect(json['id']).not_to eq nil
          expect(json['message']).to eq '取引先を更新しました'
        end
      end

      context 'with uncorrect values' do
        let(:params) do
          {
            client: {
              cd: '  ',
              company_name:     'company_name',
              department_name:  'department_name',
              zip_code:         '000-0000',
              phone_number:     '00-0000-0000',
              memo:             'memo',
            },
          }
        end

        it 'do not update the client' do
          expect do
            patch path, params
          end.not_to change { client.reload && client.updated_at }
        end

        it 'return 422 Unprocessable Entity code and message' do
          patch path, params

          expect(response).not_to be_success
          expect(response.status).to eq 422

          expect(json['message']).to eq '取引先が更新できませんでした'
        end
      end
    end

    context 'with not exist client id' do
      let(:path) { "/api/clients/0" }

      it 'return 404 Not Found code and message' do
        patch path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end
end
