require 'rails_helper'

RSpec.describe 'project_keys request' do
  let!(:user) { create(:user) }

  before { login(user) }

  describe "GET /api/projects/key/:project_type" do
    let!(:project1)  { create(:contracted_project,   key: '16D001A', contract_type: 'lump_sum') }
    let!(:project2)  { create(:contracted_project,   key: '16S001A', contract_type: 'lump_sum',    is_using_ses: true) }
    let!(:project3)  { create(:contracted_project,   key: '16K001A', contract_type: 'uasimandate') }
    let!(:project4)  { create(:contracted_project,   key: '16K002A', contract_type: 'uasimandate') }
    let!(:project5)  { create(:contracted_project,   key: '16K003A', contract_type: 'consignment') }
    let!(:project7)  { create(:contracted_project,   key: '16S002A', contract_type: 'consignment', is_using_ses: true) }
    let!(:project8)  { create(:contracted_project,   key: '16M001A', contract_type: 'maintenance') }
    let!(:project9)  { create(:uncontracted_project, key: '16D002B') }

    context 'defined contract type' do
      context 'GET /api/projects/key/lump_sum' do
        let(:path) { '/api/projects/key/lump_sum' }

        it 'return key with identifier D and ending A' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['key']).to eq '16D003A'
        end
      end

      context 'GET /api/projects/key/uncontracted' do
        let(:path) { '/api/projects/key/uncontracted' }

        it 'return key with identifier D and ending B' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['key']).to eq '16D003B'
        end
      end

      context 'GET /api/projects/key/uasimandate' do
        let(:path) { '/api/projects/key/uasimandate' }

        it 'return key with identifier K and ending A' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['key']).to eq '16K004A'
        end
      end

      context 'GET /api/projects/key/consignment' do
        let(:path) { '/api/projects/key/consignment' }

        it 'return key with identifier K and ending A' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['key']).to eq '16K004A'
        end
      end

      context 'GET /api/projects/key/maintenance' do
        let(:path) { '/api/projects/key/maintenance' }

        it 'return key with identifier M and ending A' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['key']).to eq '16M002A'
        end
      end

      context 'GET /api/projects/key/ses' do
        let(:path) { '/api/projects/key/ses' }

        it 'return key with identifier S and ending A' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['key']).to eq '16S003A'
        end
      end

      context 'GET /api/projects/key/other' do
        let(:path) { '/api/projects/key/other' }

        it 'return key with identifier W and ending A' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['key']).to eq '16W001A'
        end
      end
    end

    context 'undefined contract type' do
      let(:path) { '/api/projects/key/xxx' }

      it 'return 404 Not Found code and message' do
        get path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end
end
