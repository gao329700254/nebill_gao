require 'rails_helper'

RSpec.describe 'projects request' do
  describe 'POST /api/projects' do
    let(:path) { "/api/projects" }

    context 'with correct parameter' do
      let(:params) do
        {
          project: {
            key: 'key',
            name: 'name',
            contract_type: 'lump_sum',
            start_on: '2015-01-01',
            end_on:   '2015-10-31',
            amount:   123,
            billing_company_name:    'billing_company_name',
            billing_department_name: 'billing_department_name',
            billing_personnel_names: ['billing_personnel_names'],
            billing_address:         'billing_address',
            billing_zip_code:        'billing_zip_code',
            billing_memo:            'billing_memo',
            orderer_company_name:    'orderer_company_name',
            orderer_department_name: 'orderer_department_name',
            orderer_personnel_names: ['orderer_personnel_names'],
            orderer_address:         'orderer_address',
            orderer_zip_code:        'orderer_zip_code',
            orderer_memo:            'orderer_memo',
          },
        }
      end

      it 'create a project' do
        expect do
          post path, params
        end.to change(Project, :count).by(1)
      end

      it 'return success code and message' do
        post path, params

        expect(response).to be_success
        expect(response.status).to eq 201

        expect(json['id']).not_to eq nil
        expect(json['message']).to eq 'プロジェクトを作成しました'
      end
    end

    context 'with uncorrect parameter' do
      let(:params) do
        {
          project: {
            key: '',
            name: 'name',
            contract_type: 'lump_sum',
            start_on: '2015-01-01',
            end_on:   '2015-10-31',
            amount:   123,
            billing_company_name:    'billing_company_name',
            billing_department_name: 'billing_department_name',
            billing_personnel_names: ['billing_personnel_names'],
            billing_address:         'billing_address',
            billing_zip_code:        'billing_zip_code',
            billing_memo:            'billing_memo',
            orderer_company_name:    'orderer_company_name',
            orderer_department_name: 'orderer_department_name',
            orderer_personnel_names: ['orderer_personnel_names'],
            orderer_address:         'orderer_address',
            orderer_zip_code:        'orderer_zip_code',
            orderer_memo:            'orderer_memo',
          },
        }
      end

      it 'do not create a project' do
        expect do
          post path, params
        end.not_to change(Project, :count)
      end

      it 'return 422 Unprocessable Entity code and message' do
        post path, params

        expect(response).not_to be_success
        expect(response.status).to eq 422

        expect(json['message']).to eq 'プロジェクトが作成できませんでした'
      end
    end
  end

end
