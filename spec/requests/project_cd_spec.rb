require 'rails_helper'

RSpec.describe 'project_cds request' do
  let!(:user) { create(:user) }

  before { login(user) }

  describe "GET /api/projects/cd/:project_type" do
    let!(:project1)  { create(:contracted_project,   cd: '16D001A', contract_type: 'lump_sum') }
    let!(:project2)  { create(:contracted_project,   cd: '16S001A', contract_type: 'lump_sum',    is_using_ses: true) }
    let!(:project3)  { create(:contracted_project,   cd: '16K001A', contract_type: 'uasimandate') }
    let!(:project4)  { create(:contracted_project,   cd: '16K002A', contract_type: 'uasimandate') }
    let!(:project5)  { create(:contracted_project,   cd: '16K003A', contract_type: 'consignment') }
    let!(:project7)  { create(:contracted_project,   cd: '16S002A', contract_type: 'consignment', is_using_ses: true) }
    let!(:project8)  { create(:contracted_project,   cd: '16M001A', contract_type: 'maintenance') }
    let!(:project9)  { create(:uncontracted_project, cd: '16D002B') }

    context 'defined contract type' do
      context 'GET /api/projects/cd/lump_sum' do
        let(:path) { '/api/projects/cd/lump_sum' }

        it 'return cd with identifier D and ending A' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['cd']).to eq '16D003A'
        end
      end

      context 'GET /api/projects/cd/uncontracted' do
        let(:path) { '/api/projects/cd/uncontracted' }

        it 'return cd with identifier D and ending B' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['cd']).to eq '16D003B'
        end
      end

      context 'GET /api/projects/cd/uasimandate' do
        let(:path) { '/api/projects/cd/uasimandate' }

        it 'return cd with identifier K and ending A' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['cd']).to eq '16K004A'
        end
      end

      context 'GET /api/projects/cd/consignment' do
        let(:path) { '/api/projects/cd/consignment' }

        it 'return cd with identifier K and ending A' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['cd']).to eq '16K004A'
        end
      end

      context 'GET /api/projects/cd/maintenance' do
        let(:path) { '/api/projects/cd/maintenance' }

        it 'return cd with identifier M and ending A' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['cd']).to eq '16M002A'
        end
      end

      context 'GET /api/projects/cd/ses' do
        let(:path) { '/api/projects/cd/ses' }

        it 'return cd with identifier S and ending A' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['cd']).to eq '16S003A'
        end
      end

      context 'GET /api/projects/cd/other' do
        let(:path) { '/api/projects/cd/other' }

        it 'return cd with identifier W and ending A' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['cd']).to eq '16W001A'
        end
      end
    end

    context 'undefined contract type' do
      let(:path) { '/api/projects/cd/xxx' }

      it 'return 404 Not Found code and message' do
        get path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end
end
