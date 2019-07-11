require 'rails_helper'

RSpec.describe 'project_cds request' do
  let!(:user) { create(:user) }

  before { login(user) }

  describe "GET /api/projects/create_cd/:project_type" do
    let!(:project1)  { create(:contracted_project,   cd: "#{year}D001", contract_type: 'lump_sum') }
    let!(:project2)  { create(:contracted_project,   cd: "#{year}S001", contract_type: 'lump_sum',    is_using_ses: true) }
    let!(:project3)  { create(:contracted_project,   cd: "#{year}K001", contract_type: 'consignment') }
    let!(:project4)  { create(:contracted_project,   cd: "#{year}S002", contract_type: 'consignment', is_using_ses: true) }
    let!(:project5)  { create(:contracted_project,   cd: "#{year}M001", contract_type: 'maintenance') }
    let!(:project6)  { create(:uncontracted_project, cd: "#{year}D002") }
    let!(:year)   { Time.zone.today.strftime("%y") }

    context 'defined contract type' do
      context 'GET /api/projects/create_cd/lump_sum' do
        let(:path) { '/api/projects/create_cd/lump_sum' }

        it 'return cd with identifier D' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['cd']).to eq "#{year}D003"
        end
      end

      context 'GET /api/projects/create_cd/uncontracted' do
        let(:path) { '/api/projects/create_cd/uncontracted' }

        it 'return cd with identifier D' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['cd']).to eq "#{year}D003"
        end
      end

      context 'GET /api/projects/create_cd/consignment' do
        let(:path) { '/api/projects/create_cd/consignment' }

        it 'return cd with identifier K' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['cd']).to eq "#{year}K002"
        end
      end

      context 'GET /api/projects/create_cd/maintenance' do
        let(:path) { '/api/projects/create_cd/maintenance' }

        it 'return cd with identifier M' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['cd']).to eq "#{year}M002"
        end
      end

      context 'GET /api/projects/create_cd/ses' do
        let(:path) { '/api/projects/create_cd/ses' }

        it 'return cd with identifier S' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['cd']).to eq "#{year}S003"
        end
      end

      context 'GET /api/projects/create_cd/other' do
        let(:path) { '/api/projects/create_cd/other' }

        it 'return cd with identifier W' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200

          expect(json['cd']).to eq "#{year}W001"
        end
      end
    end

    context 'undefined contract type' do
      let(:path) { '/api/projects/create_cd/xxx' }

      it 'return 404 Not Found code and message' do
        get path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end
end
