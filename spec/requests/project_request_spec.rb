require 'rails_helper'

RSpec.describe 'projects request' do
  let!(:user) { create(:user) }

  before { login(user) }

  describe 'GET /api/projects' do
    let!(:project1) { create(:contracted_project) }
    let!(:project2) { create(:contracted_project) }
    let!(:project3) { create(:uncontracted_project) }
    let(:path) { "/api/projects" }

    it 'return a list of projects' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 3

      expect(json[0]['id']).to                       eq project1.id
      expect(json[0]['group_id']).to                 eq project1.group_id
      expect(json[0]['key']).to                      eq project1.key
      expect(json[0]['name']).to                     eq project1.name
      expect(json[0]['contracted']).to               eq project1.contracted
      expect(json[0]['contract_on']).to              eq project1.contract_on.strftime("%Y-%m-%d")
      expect(json[0]['is_using_ses']).to             eq project1.is_using_ses
      expect(json[0]['contractual_coverage']).to     eq project1.contractual_coverage
      expect(json[0]['contract_type']).to            eq project1.contract_type
      expect(json[0]['start_on']).to                 eq project1.start_on.strftime("%Y-%m-%d")
      expect(json[0]['end_on']).to                   eq project1.end_on.strftime("%Y-%m-%d")
      expect(json[0]['amount']).to                   eq project1.amount
      expect(json[0]['billing_company_name']).to     eq project1.billing_company_name
      expect(json[0]['billing_department_name']).to  eq project1.billing_department_name
      expect(json[0]['billing_personnel_names']).to  eq project1.billing_personnel_names
      expect(json[0]['billing_address']).to          eq project1.billing_address
      expect(json[0]['billing_zip_code']).to         eq project1.billing_zip_code
      expect(json[0]['billing_memo']).to             eq project1.billing_memo
      expect(json[0]['orderer_company_name']).to     eq project1.orderer_company_name
      expect(json[0]['orderer_department_name']).to  eq project1.orderer_department_name
      expect(json[0]['orderer_personnel_names']).to  eq project1.orderer_personnel_names
      expect(json[0]['orderer_address']).to          eq project1.orderer_address
      expect(json[0]['orderer_zip_code']).to         eq project1.orderer_zip_code
      expect(json[0]['orderer_memo']).to             eq project1.orderer_memo
      expect(json[0]['created_at']).to               eq project1.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      expect(json[0]['updated_at']).to               eq project1.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    end
  end

  describe 'POST /api/projects' do
    let(:path) { "/api/projects" }

    context 'with correct parameter' do
      let(:params) do
        {
          project: {
            group_id: 1,
            key: 'key',
            name: 'name',
            contracted: true,
            contract_on: '2015-01-01',
            contract_type: 'lump_sum',
            is_using_ses: true,
            contractual_coverage: 'development',
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

        project = Project.first
        expect(project.group_id).to eq 1
        expect(project.key).to eq  'KEY'
        expect(project.name).to eq  'name'
        expect(project.contracted).to eq  true
        expect(project.contract_on).to eq  Date.parse('2015-01-01')
        expect(project.contract_type).to eq  'lump_sum'
        expect(project.is_using_ses).to eq  true
        expect(project.contractual_coverage).to eq  'development'
        expect(project.start_on).to eq  Date.parse('2015-01-01')
        expect(project.end_on).to eq    Date.parse('2015-10-31')
        expect(project.amount).to eq    123
        expect(project.billing_company_name).to eq     'billing_company_name'
        expect(project.billing_department_name).to eq  'billing_department_name'
        expect(project.billing_personnel_names).to eq  ['billing_personnel_names']
        expect(project.billing_address).to eq          'billing_address'
        expect(project.billing_zip_code).to eq         'billing_zip_code'
        expect(project.billing_memo).to eq             'billing_memo'
        expect(project.orderer_company_name).to eq     'orderer_company_name'
        expect(project.orderer_department_name).to eq  'orderer_department_name'
        expect(project.orderer_personnel_names).to eq  ['orderer_personnel_names']
        expect(project.orderer_address).to eq          'orderer_address'
        expect(project.orderer_zip_code).to eq         'orderer_zip_code'
        expect(project.orderer_memo).to eq             'orderer_memo'
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
            group_id: 1,
            key: '',
            name: 'name',
            contracted: 'true',
            contract_on: '2015-01-01',
            contract_type: 'lump_sum',
            is_using_ses: false,
            contractual_coverage: 'development',
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

  describe 'GET /api/project/:id' do
    context 'with exist project id' do
      let(:project) { create(:contracted_project) }
      let(:path) { "/api/projects/#{project.id}" }

      it 'return the project' do
        get path

        expect(response).to be_success
        expect(response.status).to eq 200
        expect(json['id']).to                       eq project.id
        expect(json['group_id']).to                 eq project.group_id
        expect(json['key']).to                      eq project.key
        expect(json['name']).to                     eq project.name
        expect(json['contracted']).to               eq project.contracted
        expect(json['contract_on']).to              eq project.contract_on.strftime("%Y-%m-%d")
        expect(json['is_using_ses']).to             eq project.is_using_ses
        expect(json['contractual_coverage']).to     eq project.contractual_coverage
        expect(json['contract_type']).to            eq project.contract_type
        expect(json['start_on']).to                 eq project.start_on.strftime("%Y-%m-%d")
        expect(json['end_on']).to                   eq project.end_on.strftime("%Y-%m-%d")
        expect(json['amount']).to                   eq project.amount
        expect(json['billing_company_name']).to     eq project.billing_company_name
        expect(json['billing_department_name']).to  eq project.billing_department_name
        expect(json['billing_personnel_names']).to  eq project.billing_personnel_names
        expect(json['billing_address']).to          eq project.billing_address
        expect(json['billing_zip_code']).to         eq project.billing_zip_code
        expect(json['billing_memo']).to             eq project.billing_memo
        expect(json['orderer_company_name']).to     eq project.orderer_company_name
        expect(json['orderer_department_name']).to  eq project.orderer_department_name
        expect(json['orderer_personnel_names']).to  eq project.orderer_personnel_names
        expect(json['orderer_address']).to          eq project.orderer_address
        expect(json['orderer_zip_code']).to         eq project.orderer_zip_code
        expect(json['orderer_memo']).to             eq project.orderer_memo
        expect(json['created_at']).to               eq project.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
        expect(json['updated_at']).to               eq project.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      end
    end

    context 'with not exist project id' do
      let(:path) { '/api/projects/0' }

      it 'return 404 Not Found code and message' do
        get path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end

  describe 'PATCH /api/projects' do
    context 'with exist project id' do
      let(:project) { create(:contracted_project) }
      let(:path) { "/api/projects/#{project.id}" }

      context 'with correct parameter' do
        let(:params) do
          {
            project: {
              group_id: 1,
              key: 'key',
              name: 'name',
              contracted: true,
              contract_on: '2015-01-01',
              contract_type: 'lump_sum',
              is_using_ses: true,
              contractual_coverage: 'development',
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

        it 'update the project' do
          expect do
            patch path, params
          end.to change { project.reload && project.updated_at }

          expect(project.group_id).to eq  1
          expect(project.key).to eq  'KEY'
          expect(project.name).to eq  'name'
          expect(project.contracted).to eq  true
          expect(project.contract_on).to eq  Date.parse('2015-01-01')
          expect(project.contract_type).to eq  'lump_sum'
          expect(project.is_using_ses).to eq  true
          expect(project.contractual_coverage).to eq  'development'
          expect(project.start_on).to eq  Date.parse('2015-01-01')
          expect(project.end_on).to eq    Date.parse('2015-10-31')
          expect(project.amount).to eq    123
          expect(project.billing_company_name).to eq     'billing_company_name'
          expect(project.billing_department_name).to eq  'billing_department_name'
          expect(project.billing_personnel_names).to eq  ['billing_personnel_names']
          expect(project.billing_address).to eq          'billing_address'
          expect(project.billing_zip_code).to eq         'billing_zip_code'
          expect(project.billing_memo).to eq             'billing_memo'
          expect(project.orderer_company_name).to eq     'orderer_company_name'
          expect(project.orderer_department_name).to eq  'orderer_department_name'
          expect(project.orderer_personnel_names).to eq  ['orderer_personnel_names']
          expect(project.orderer_address).to eq          'orderer_address'
          expect(project.orderer_zip_code).to eq         'orderer_zip_code'
          expect(project.orderer_memo).to eq             'orderer_memo'
        end

        it 'return success code and message' do
          patch path, params

          expect(response).to be_success
          expect(response.status).to eq 201

          expect(json['id']).not_to eq nil
          expect(json['message']).to eq 'プロジェクトを更新しました'
        end
      end

      context 'with uncorrect parameter' do
        let(:params) do
          {
            project: {
              group_id: 1,
              key: '',
              name: 'name',
              contracted: true,
              contract_on: '2015-01-01',
              contract_type: 'lump_sum',
              is_using_ses: false,
              contractual_coverage: 'development',
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

        it 'do not update the project' do
          expect do
            patch path, params
          end.not_to change { project.reload && project.updated_at }
        end

        it 'return 422 Unprocessable Entity code and message' do
          patch path, params

          expect(response).not_to be_success
          expect(response.status).to eq 422

          expect(json['message']).to eq 'プロジェクトが更新できませんでした'
        end
      end
    end

    context 'with not exist project id' do
      let(:path) { '/api/projects/0' }

      it 'return 404 Not Found code and message' do
        patch path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end
end
