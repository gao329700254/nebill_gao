require 'rails_helper'

RSpec.describe 'projects request', versioning: true do
  let!(:user) { create(:user) }

  before { login(user) }

  describe 'GET /api/projects' do
    let!(:project1) { create(:contracted_project, cd: '17D001A', is_regular_contract: true) }
    let!(:project2) { create(:contracted_project, cd: '17D002A', status: :finished) }
    let!(:project3) { create(:uncontracted_project, cd: '17D001B') }
    let(:params) { { today: Time.zone.now } }
    let(:path) { "/api/projects/search_result" }

    it 'return a list of projects' do
      post path, params

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 1

      expect(json[0]['id']).to                       eq project1.id
      expect(json[0]['group_id']).to                 eq project1.group_id
      expect(json[0]['cd']).to                       eq project1.cd
      expect(json[0]['name']).to                     eq project1.name
      expect(json[0]['contracted']).to               eq project1.contracted
      expect(json[0]['contract_on']).to              eq project1.contract_on.strftime("%Y-%m-%d")
      expect(json[0]['is_using_ses']).to             eq project1.is_using_ses
      expect(json[0]['contract_type']).to            eq project1.contract_type
      expect(json[0]['estimated_amount']).to         eq project1.estimated_amount
      expect(json[0]['status']).to                   eq I18n.t("enumerize.defaults.status.#{project1.status}")
      expect(json[0]['is_regular_contract']).to      eq I18n.t("enumerize.defaults.regular_contract")
      expect(json[0]['start_on']).to                 eq project1.start_on.strftime("%Y-%m-%d")
      expect(json[0]['end_on']).to                   eq project1.end_on.strftime("%Y-%m-%d")
      expect(json[0]['amount']).to                   eq project1.amount
      expect(json[0]['payment_type']).to             eq project1.payment_type
      expect(json[0]['billing_company_name']).to     eq project1.billing_company_name
      expect(json[0]['billing_department_name']).to  eq project1.billing_department_name
      expect(json[0]['billing_personnel_names']).to  eq project1.billing_personnel_names
      expect(json[0]['billing_address']).to          eq project1.billing_address
      expect(json[0]['billing_zip_code']).to         eq project1.billing_zip_code
      expect(json[0]['billing_phone_number']).to     eq project1.billing_phone_number
      expect(json[0]['billing_memo']).to             eq project1.billing_memo
      expect(json[0]['orderer_company_name']).to     eq project1.orderer_company_name
      expect(json[0]['orderer_department_name']).to  eq project1.orderer_department_name
      expect(json[0]['orderer_personnel_names']).to  eq project1.orderer_personnel_names
      expect(json[0]['orderer_address']).to          eq project1.orderer_address
      expect(json[0]['orderer_zip_code']).to         eq project1.orderer_zip_code
      expect(json[0]['orderer_phone_number']).to     eq project1.orderer_phone_number
      expect(json[0]['orderer_memo']).to             eq project1.orderer_memo
      expect(json[0]['created_at']).to               eq project1.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      expect(json[0]['updated_at']).to               eq project1.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    end
  end

  describe 'POST /api/projects' do
    let(:path) { "/api/projects" }
    let(:project_group) { create(:project_group) }

    context 'with correct parameter' do
      let(:params) do
        {
          project: {
            group_id: project_group.id,
            cd: '17D001A',
            name: 'name',
            contracted: true,
            contract_on: '2015-01-01',
            status: 'receive_order',
            contract_type: 'lump_sum',
            estimated_amount: 123,
            is_using_ses: true,
            is_regular_contract: true,
            start_on: '2015-01-01',
            end_on:   '2015-10-31',
            amount: 123,
            payment_type: 'bill_on_15th_and_payment_on_end_of_next_month',
            billing_company_name:    'billing_company_name',
            billing_department_name: 'billing_department_name',
            billing_personnel_names: ['billing_personnel_names'],
            billing_address:         'billing_address',
            billing_zip_code:        'billing_zip_code',
            billing_phone_number:    'billing_phone_number',
            billing_memo:            'billing_memo',
            orderer_company_name:    'orderer_company_name',
            orderer_department_name: 'orderer_department_name',
            orderer_personnel_names: ['orderer_personnel_names'],
            orderer_address:         'orderer_address',
            orderer_zip_code:        'orderer_zip_code',
            orderer_phone_number:    'orderer_phone_number',
            orderer_memo:            'orderer_memo',
          },
        }
      end

      it 'create a project' do
        expect do
          post path, params
        end.to change(Project, :count).by(1)

        project = Project.first
        expect(project.group_id).to eq project_group.id
        expect(project.cd).to eq  '17D001A'
        expect(project.name).to eq  'name'
        expect(project.contracted).to eq  true
        expect(project.contract_on.to_s).to eq  '2015-01-01'
        expect(project.status).to eq  'receive_order'
        expect(project.contract_type).to eq  'lump_sum'
        expect(project.estimated_amount).to eq  123
        expect(project.is_using_ses).to eq  true
        expect(project.is_regular_contract).to eq  true
        expect(project.start_on.to_s).to eq '2015-01-01'
        expect(project.end_on.to_s).to eq   '2015-10-31'
        expect(project.amount).to eq 123
        expect(project.payment_type).to eq 'bill_on_15th_and_payment_on_end_of_next_month'
        expect(project.billing_company_name).to eq     'billing_company_name'
        expect(project.billing_department_name).to eq  'billing_department_name'
        expect(project.billing_personnel_names).to eq  ['billing_personnel_names']
        expect(project.billing_address).to eq          'billing_address'
        expect(project.billing_zip_code).to eq         'billing_zip_code'
        expect(project.billing_phone_number).to eq     'billing_phone_number'
        expect(project.billing_memo).to eq             'billing_memo'
        expect(project.orderer_company_name).to eq     'orderer_company_name'
        expect(project.orderer_department_name).to eq  'orderer_department_name'
        expect(project.orderer_personnel_names).to eq  ['orderer_personnel_names']
        expect(project.orderer_address).to eq          'orderer_address'
        expect(project.orderer_zip_code).to eq         'orderer_zip_code'
        expect(project.orderer_phone_number).to eq     'orderer_phone_number'
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
            cd: '',
            name: 'name',
            contracted: 'true',
            contract_on: '2015-01-01',
            status: 'receive_order',
            contract_type: 'lump_sum',
            estimated_amount: 123,
            is_using_ses: false,
            is_regular_contract: false,
            start_on: '2015-01-01',
            end_on:   '2015-10-31',
            amount: 123,
            payment_type: 'bill_on_15th_and_payment_on_end_of_next_month',
            billing_company_name:    'billing_company_name',
            billing_department_name: 'billing_department_name',
            billing_personnel_names: ['billing_personnel_names'],
            billing_address:         'billing_address',
            billing_zip_code:        'billing_zip_code',
            billing_phone_number:    'billing_phone_number',
            billing_memo:            'billing_memo',
            orderer_company_name:    'orderer_company_name',
            orderer_department_name: 'orderer_department_name',
            orderer_personnel_names: ['orderer_personnel_names'],
            orderer_address:         'orderer_address',
            orderer_zip_code:        'orderer_zip_code',
            orderer_phone_number:    'orderer_phone_number',
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
        expect(json['cd']).to                       eq project.cd
        expect(json['name']).to                     eq project.name
        expect(json['contracted']).to               eq project.contracted
        expect(json['contract_on']).to              eq project.contract_on.strftime("%Y-%m-%d")
        expect(json['status']).to                   eq project.status
        expect(json['is_using_ses']).to             eq project.is_using_ses
        expect(json['is_regular_contract']).to      eq project.is_regular_contract
        expect(json['contract_type']).to            eq project.contract_type
        expect(json['estimated_amount']).to         eq project.estimated_amount
        expect(json['start_on']).to                 eq project.start_on.strftime("%Y-%m-%d")
        expect(json['end_on']).to                   eq project.end_on.strftime("%Y-%m-%d")
        expect(json['amount']).to                   eq project.amount
        expect(json['payment_type']).to             eq project.payment_type
        expect(json['billing_company_name']).to     eq project.billing_company_name
        expect(json['billing_department_name']).to  eq project.billing_department_name
        expect(json['billing_personnel_names']).to  eq project.billing_personnel_names
        expect(json['billing_address']).to          eq project.billing_address
        expect(json['billing_zip_code']).to         eq project.billing_zip_code
        expect(json['billing_phone_number']).to     eq project.billing_phone_number
        expect(json['billing_memo']).to             eq project.billing_memo
        expect(json['orderer_company_name']).to     eq project.orderer_company_name
        expect(json['orderer_department_name']).to  eq project.orderer_department_name
        expect(json['orderer_personnel_names']).to  eq project.orderer_personnel_names
        expect(json['orderer_address']).to          eq project.orderer_address
        expect(json['orderer_zip_code']).to         eq project.orderer_zip_code
        expect(json['orderer_phone_number']).to     eq project.orderer_phone_number
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

  describe 'GET /api/projects/:id/select_status' do
    context 'with exist project id' do
      context 'and when bills deposit_on is not filled' do
        let(:project) { create(:contracted_project) }
        let(:path) { "/api/projects/#{project.id}/select_status" }

        it 'return the 3 status options' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200
          expect(json.count).to      eq 3
        end
      end

      context 'and when bills deposit_on is filled' do
        let(:project) { create(:contracted_project) }
        let!(:bill) { create(:bill, project: project, deposit_on: 1.day.ago) }
        let(:path) { "/api/projects/#{project.id}/select_status" }

        it 'return the 4 status options' do
          get path

          expect(response).to be_success
          expect(response.status).to eq 200
          expect(json.count).to      eq 4
        end
      end
    end

    context 'with not exist project id' do
      let(:path) { '/api/projects/0/select_status' }

      it 'return 404 Not Found code and message' do
        get path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end

  describe 'GET /api/projects/:id/last_updated_at' do

    context 'with exist project id' do
      let(:project) { create(:contracted_project) }
      let!(:bill) { create(:bill, project: project, updated_at: 1.day.since) }
      let(:path) { "/api/projects/#{project.id}/last_updated_at" }

      it 'return 200 OK' do
        get path

        expect(response).to be_success
        expect(response.status).to eq 200

        expect(json['updated_at']).to eq I18n.l(bill.updated_at.in_time_zone('Tokyo'))
        expect(json['whodunnit']).to eq ''
      end
    end

    context 'with not exist project id' do
      let(:path) { '/api/projects/0/last_updated_at' }

      it 'return 404 Not Found code and message' do
        get path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end

  describe 'PATCH /api/projects/:id' do
    context 'with exist project id' do
      let(:project) { create(:contracted_project) }
      let(:project_group) { create(:project_group) }
      let(:path) { "/api/projects/#{project.id}" }

      context 'with correct parameter' do
        let(:params) do
          {
            project: {
              group_id: project_group.id,
              cd: '17D001A',
              name: 'name',
              contracted: true,
              contract_on: '2015-01-01',
              status: 'receive_order',
              contract_type: 'lump_sum',
              estimated_amount: 123,
              is_using_ses: true,
              is_regular_contract: true,
              start_on: '2015-01-01',
              end_on:   '2015-10-31',
              amount: 123,
              payment_type: 'bill_on_15th_and_payment_on_end_of_next_month',
              billing_company_name:    'billing_company_name',
              billing_department_name: 'billing_department_name',
              billing_personnel_names: ['billing_personnel_names'],
              billing_address:         'billing_address',
              billing_zip_code:        'billing_zip_code',
              billing_phone_number:    'billing_phone_number',
              billing_memo:            'billing_memo',
              orderer_company_name:    'orderer_company_name',
              orderer_department_name: 'orderer_department_name',
              orderer_personnel_names: ['orderer_personnel_names'],
              orderer_address:         'orderer_address',
              orderer_zip_code:        'orderer_zip_code',
              orderer_phone_number:    'orderer_phone_number',
              orderer_memo:            'orderer_memo',
            },
          }
        end

        it 'update the project' do
          expect do
            patch path, params
          end.to change { project.reload && project.updated_at }

          expect(project.group_id).to eq  project_group.id
          expect(project.cd).to eq  '17D001A'
          expect(project.name).to eq  'name'
          expect(project.contracted).to eq  true
          expect(project.contract_on.to_s).to eq  '2015-01-01'
          expect(project.status).to eq  'receive_order'
          expect(project.contract_type).to eq  'lump_sum'
          expect(project.estimated_amount).to eq  123
          expect(project.is_using_ses).to eq  true
          expect(project.is_regular_contract).to eq  true
          expect(project.start_on.to_s).to eq '2015-01-01'
          expect(project.end_on.to_s).to eq   '2015-10-31'
          expect(project.amount).to eq 123
          expect(project.payment_type).to eq 'bill_on_15th_and_payment_on_end_of_next_month'
          expect(project.billing_company_name).to eq     'billing_company_name'
          expect(project.billing_department_name).to eq  'billing_department_name'
          expect(project.billing_personnel_names).to eq  ['billing_personnel_names']
          expect(project.billing_address).to eq          'billing_address'
          expect(project.billing_zip_code).to eq         'billing_zip_code'
          expect(project.billing_phone_number).to eq     'billing_phone_number'
          expect(project.billing_memo).to eq             'billing_memo'
          expect(project.orderer_company_name).to eq     'orderer_company_name'
          expect(project.orderer_department_name).to eq  'orderer_department_name'
          expect(project.orderer_personnel_names).to eq  ['orderer_personnel_names']
          expect(project.orderer_address).to eq          'orderer_address'
          expect(project.orderer_zip_code).to eq         'orderer_zip_code'
          expect(project.orderer_phone_number).to eq     'orderer_phone_number'
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
              cd: '',
              name: 'name',
              contracted: true,
              contract_on: '2015-01-01',
              status: 'receive_order',
              contract_type: 'lump_sum',
              estimated_amount: 123,
              is_using_ses: false,
              is_regular_contract: false,
              start_on: '2015-01-01',
              end_on:   '2015-10-31',
              amount: 123,
              payment_type: 'bill_on_15th_and_payment_on_end_of_next_month',
              billing_company_name:    'billing_company_name',
              billing_department_name: 'billing_department_name',
              billing_personnel_names: ['billing_personnel_names'],
              billing_address:         'billing_address',
              billing_zip_code:        'billing_zip_code',
              billing_phone_number:    'billing_phone_number',
              billing_memo:            'billing_memo',
              orderer_company_name:    'orderer_company_name',
              orderer_department_name: 'orderer_department_name',
              orderer_personnel_names: ['orderer_personnel_names'],
              orderer_address:         'orderer_address',
              orderer_zip_code:        'orderer_zip_code',
              orderer_phone_number:    'orderer_phone_number',
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

  describe 'GET /api/projects/:id/bill_default_values' do
    let!(:project) do
      create(:contracted_project, end_on: '2016-06-10', payment_type: 'bill_on_15th_and_payment_on_end_of_next_month')
    end
    let(:now) { Time.zone.parse('2016-06-01') }
    let(:path) { "/api/projects/#{project.id}/bill_default_values" }

    around { |example| Timecop.travel(now) { example.run } }

    it 'return default dates' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200

      expect(json['amount']).to        eq project.amount
      expect(json['delivery_on']).to   eq '2016-06-10'
      expect(json['acceptance_on']).to eq '2016-06-10'
      expect(json['payment_type']).to  eq 'bill_on_15th_and_payment_on_end_of_next_month'
      expect(json['bill_on']).to       eq '2016-06-15'
      expect(json['deposit_on']).to    eq nil
    end
  end

  describe 'DELETE /api/projects/:id' do
    context 'with exist project id' do
      let!(:project) { create(:contracted_project) }
      let(:path) { "/api/projects/#{project.id}" }

      it 'delete the project' do
        expect do
          delete path
        end.to change(Project, :count).by(-1)

        expect(response).to be_success
        expect(response.status).to eq 201

        expect(flash[:success]).to eq 'プロジェクトを削除しました'
      end
    end

    context 'with not exist project id' do
      let(:path) { "/api/projects/0" }

      it 'returns 404 Not Found code and message' do
        expect do
          delete path
        end.not_to change(Project, :count)

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end

  describe 'POST /api/projects/create_with_client' do
    let(:path) { "/api/projects/create_with_client" }
    let(:project_group) { create(:project_group) }

    context 'with correct parameter' do
      let(:params) do
        {
          project: {
            group_id: project_group.id,
            cd: '17D001A',
            name: 'name',
            contracted: true,
            contract_on: '2015-01-01',
            status: 'receive_order',
            contract_type: 'lump_sum',
            estimated_amount: 123,
            is_using_ses: true,
            is_regular_contract: true,
            start_on: '2015-01-01',
            end_on:   '2015-10-31',
            amount: 123,
            payment_type: 'bill_on_15th_and_payment_on_end_of_next_month',
            billing_company_name:    'billing_company_name',
            billing_department_name: 'billing_department_name',
            billing_personnel_names: ['billing_personnel_names'],
            billing_address:         'billing_address',
            billing_zip_code:        'billing_zip_code',
            billing_phone_number:    'billing_phone_number',
            billing_memo:            'billing_memo',
            orderer_company_name:    'orderer_company_name',
            orderer_department_name: 'orderer_department_name',
            orderer_personnel_names: ['orderer_personnel_names'],
            orderer_address:         'orderer_address',
            orderer_zip_code:        'orderer_zip_code',
            orderer_phone_number:    'orderer_phone_number',
            orderer_memo:            'orderer_memo',
          },

          client: {
            company_name:     'orderer_company_name',
            department_name:  'orderer_department_name',
            address:          'orderer_address',
            zip_code:         'orderer_zip_code',
            phone_number:     'orderer_phone_number',
          },
        }
      end

      it 'create a project and client' do
        expect do
          post path, params
        end.to change(Project, :count).by(1).and change(Client, :count).by(1)

        project = Project.first
        client = Client.first
        expect(project.group_id).to eq project_group.id
        expect(project.cd).to eq  '17D001A'
        expect(project.name).to eq  'name'
        expect(project.contracted).to eq  true
        expect(project.contract_on.to_s).to eq  '2015-01-01'
        expect(project.status).to eq  'receive_order'
        expect(project.contract_type).to eq  'lump_sum'
        expect(project.estimated_amount).to eq  123
        expect(project.is_using_ses).to eq  true
        expect(project.is_regular_contract).to eq  true
        expect(project.start_on.to_s).to eq '2015-01-01'
        expect(project.end_on.to_s).to eq   '2015-10-31'
        expect(project.amount).to eq 123
        expect(project.payment_type).to eq 'bill_on_15th_and_payment_on_end_of_next_month'
        expect(project.billing_company_name).to eq     'billing_company_name'
        expect(project.billing_department_name).to eq  'billing_department_name'
        expect(project.billing_personnel_names).to eq  ['billing_personnel_names']
        expect(project.billing_address).to eq          'billing_address'
        expect(project.billing_zip_code).to eq         'billing_zip_code'
        expect(project.billing_phone_number).to eq     'billing_phone_number'
        expect(project.billing_memo).to eq             'billing_memo'
        expect(project.orderer_company_name).to eq     'orderer_company_name'
        expect(project.orderer_department_name).to eq  'orderer_department_name'
        expect(project.orderer_personnel_names).to eq  ['orderer_personnel_names']
        expect(project.orderer_address).to eq          'orderer_address'
        expect(project.orderer_zip_code).to eq         'orderer_zip_code'
        expect(project.orderer_phone_number).to eq     'orderer_phone_number'
        expect(project.orderer_memo).to eq             'orderer_memo'
        expect(client.company_name).to eq              'orderer_company_name'
        expect(client.department_name).to eq           'orderer_department_name'
        expect(client.address).to eq                   'orderer_address'
        expect(client.zip_code).to eq                  'orderer_zip_code'
        expect(client.phone_number).to eq              'orderer_phone_number'
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
      context 'when client has uncorrect parameter' do
        let(:params) do
          {
            project: {
              group_id: project_group.id,
              cd: '17D001A',
              name: 'name',
              contracted: true,
              contract_on: '2015-01-01',
              status: 'receive_order',
              contract_type: 'lump_sum',
              estimated_amount: 123,
              is_using_ses: true,
              is_regular_contract: true,
              start_on: '2015-01-01',
              end_on:   '2015-10-31',
              amount: 123,
              payment_type: 'bill_on_15th_and_payment_on_end_of_next_month',
              billing_company_name:    'billing_company_name',
              billing_department_name: 'billing_department_name',
              billing_personnel_names: ['billing_personnel_names'],
              billing_address:         'billing_address',
              billing_zip_code:        'billing_zip_code',
              billing_phone_number:    'billing_phone_number',
              billing_memo:            'billing_memo',
              orderer_company_name:    'orderer_company',
              orderer_department_name: 'orderer_department_name',
              orderer_personnel_names: ['orderer_personnel_names'],
              orderer_address:         'orderer_address',
              orderer_zip_code:        'orderer_zip_code',
              orderer_phone_number:    'orderer_phone_number',
              orderer_memo:            'orderer_memo',
            },

            client: {
              company_name:     ' ',
              department_name:  'orderer_department_name',
              address:          'orderer_address',
              zip_code:         'orderer_zip_code',
              phone_number:     'orderer_phone_number',
            },
          }
        end

        it 'do not create a project and client' do
          expect do
            post path, params
          end.not_to change(Project, :count)
        end

        it 'return 422 Unprocessable Entity code and message' do
          post path, params

          expect(response).not_to be_success
          expect(response.status).to eq 422

          expect(json['message']).to eq '取引先が作成できませんでした'
          expect(json['errors']['full_messages']).to eq ['会社名を入力してください']
        end
      end
    end
  end
end
