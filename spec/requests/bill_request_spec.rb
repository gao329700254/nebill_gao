require 'rails_helper'

RSpec.describe 'bills request' do
  let!(:user) { create(:user) }

  before { login(user) }

  describe "GET /api/bills" do
    let!(:bill1) { create(:bill) }
    let!(:bill2) { create(:bill) }
    let!(:bill3) { create(:bill) }
    let!(:bill4) { create(:bill) }
    let!(:user1) { create(:user) }
    let!(:applicant1) { create(:bill_applicant, bill: bill1, user: user1) }
    let!(:applicant2) { create(:bill_applicant, bill: bill2, user: user1) }
    let!(:applicant3) { create(:bill_applicant, bill: bill3, user: user1) }
    let!(:applicant4) { create(:bill_applicant, bill: bill4, user: user1) }
    let(:path)   { "/api/bills" }

    it 'return a list of bills and projects that belong to the bill' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 4

      expect(json[0]['id']).to                               eq bill4.id
      expect(json[0]['project_id']).to                       eq bill4.project_id
      expect(json[0]['cd']).to                               eq bill4.cd
      expect(json[0]['amount']).to                           eq bill4.amount
      expect(json[0]['delivery_on']).to                      eq bill4.delivery_on.strftime("%Y-%m-%d")
      expect(json[0]['acceptance_on']).to                    eq bill4.acceptance_on.strftime("%Y-%m-%d")
      expect(json[0]['payment_type']).to                     eq I18n.t("enumerize.defaults.payment_type.#{bill4.payment_type}")
      expect(json[0]['bill_on']).to                          eq bill4.bill_on.strftime("%Y-%m-%d")
      expect(json[0]['expected_deposit_on']).to              eq bill4.expected_deposit_on.strftime("%Y-%m-%d")
      expect(json[0]['deposit_on']).to                       eq bill4.deposit_on ? bill1.deposit_on.strftime("%Y-%m-%d") : nil
      expect(json[0]['memo']).to                             eq bill4.memo
      expect(json[0]['applicant_name']).to                   eq bill4.applicant.user.name
      expect(json[0]['status']).to                           eq bill4.status_i18n
      expect(json[0]['created_at']).to                       eq bill4.created_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
      expect(json[0]['updated_at']).to                       eq bill4.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
      expect(json[0]['project']['name']).to                  eq bill4.project.name
      expect(json[0]['project']['billing_company_name']).to  eq bill4.project.billing_company_name
    end
  end

  describe 'GET /api/projects/:project_id/bills' do
    context 'with exist bill id' do
      let(:project) { create(:project) }
      let!(:bill1)  { create(:bill, project: project) }
      let!(:bill2)  { create(:bill, project: project) }
      let!(:bill3)  { create(:bill, project: project) }
      let!(:bill4)  { create(:bill) }
      let!(:user1) { create(:user) }
      let!(:applicant1) { create(:bill_applicant, bill: bill1, user: user1) }
      let!(:applicant2) { create(:bill_applicant, bill: bill2, user: user1) }
      let!(:applicant3) { create(:bill_applicant, bill: bill3, user: user1) }
      let!(:applicant4) { create(:bill_applicant, bill: bill4, user: user1) }
      let(:path)    { "/api/projects/#{project.id}/bills" }

      it 'returns a list of bills which belong to project' do
        get path

        expect(response).to be_success
        expect(response.status).to eq 200
        expect(json.count).to eq 3

        json.sort_by! { |x| x['id'].to_i }

        expect(json[0]['id']).to                               eq bill1.id
        expect(json[0]['project_id']).to                       eq bill1.project_id
        expect(json[0]['cd']).to                               eq bill1.cd
        expect(json[0]['amount']).to                           eq bill1.amount
        expect(json[0]['delivery_on']).to                      eq bill1.delivery_on.strftime("%Y-%m-%d")
        expect(json[0]['acceptance_on']).to                    eq bill1.acceptance_on.strftime("%Y-%m-%d")
        expect(json[0]['payment_type']).to                     eq I18n.t("enumerize.defaults.payment_type.#{bill1.payment_type}")
        expect(json[0]['bill_on']).to                          eq bill1.bill_on ? bill1.bill_on.strftime("%Y-%m-%d") : nil
        expect(json[0]['expected_deposit_on']).to              eq bill1.expected_deposit_on.strftime("%Y-%m-%d")
        expect(json[0]['deposit_on']).to                       eq bill1.deposit_on ? bill1.deposit_on.strftime("%Y-%m-%d") : nil
        expect(json[0]['memo']).to                             eq bill1.memo
        expect(json[0]['applicant_name']).to                   eq bill1.applicant.user.name
        expect(json[0]['status']).to                           eq bill1.status_i18n
        expect(json[0]['created_at']).to                       eq bill1.created_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
        expect(json[0]['updated_at']).to                       eq bill1.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
        expect(json[0]['project']['name']).to                  eq bill1.project.name
        expect(json[0]['project']['billing_company_name']).to  eq bill1.project.billing_company_name
      end
    end

    context 'with not exist project id' do
      let(:path) { '/api/projects/0/bills' }

      it 'return 404 Not Found code and message' do
        get path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end

  describe 'GET /api/bills/:id' do
    context 'with exist bill id' do
      let!(:bill) { create(:bill) }
      let!(:user1) { create(:user) }
      let!(:applicant1) { create(:bill_applicant, bill: bill, user: user1) }
      let(:path)  { "/api/bills/#{bill.id}" }

      it 'return the bill' do
        get path

        expect(response).to be_success
        expect(response.status).to eq 200

        expect(json['id']).to                  eq bill.id
        expect(json['cd']).to                  eq bill.cd
        expect(json['project_name']).to        eq bill.project_name
        expect(json['company_name']).to        eq bill.company_name
        expect(json['amount']).to              eq bill.amount
        expect(json['delivery_on']).to         eq bill.delivery_on.strftime("%Y-%m-%d")
        expect(json['acceptance_on']).to       eq bill.acceptance_on.strftime("%Y-%m-%d")
        expect(json['payment_type']).to        eq bill.payment_type
        expect(json['bill_on']).to             eq bill.bill_on ? bill.bill_on.strftime("%Y-%m-%d") : nil
        expect(json['expected_deposit_on']).to eq bill.expected_deposit_on.strftime("%Y-%m-%d")
        expect(json['deposit_on']).to          eq bill.deposit_on ? bill.deposit_on.strftime("%Y-%m-%d") : nil
        expect(json['status']).to              eq bill.status_i18n
        expect(json['memo']).to                eq bill.memo
        expect(json['created_at']).to          eq bill.created_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
        expect(json['updated_at']).to          eq I18n.l(bill.updated_at.in_time_zone('Tokyo'))
        # expect(json['shodunnit']).to
      end

      context 'with not exist bill id' do
        let(:path) { '/api/bills/0' }

        it 'return 404 Not Found code and message' do
          get path

          expect(response).not_to be_success
          expect(response.status).to eq 404

          expect(json['message']).to eq 'リソースが見つかりませんでした'
        end
      end
    end
  end

  describe 'POST /api/projects/:project_id/bill' do
    let(:project) { create(:contracted_project) }
    let(:path) { "/api/projects/#{project.id}/bills" }

    context 'with correct parameter' do
      let(:params) do
        {
          bill: {
            cd:                  'BILL-1',
            project_name:        project.name,
            company_name:        project.billing_company_name,
            amount:              100_000,
            delivery_on:         '2016-01-01',
            acceptance_on:       '2016-01-02',
            payment_type:        'bill_on_15th_and_payment_on_end_of_next_month',
            bill_on:             '2016-01-04',
            expected_deposit_on: '2016-01-05',
            memo:                'memo',
            create_user_id:      user.id,
          },
        }
      end

      it 'create a bill' do
        expect do
          post path, params: params
        end.to change(Bill, :count).by(1)

        bill = Bill.first
        expect(bill.project).to                  eq project
        expect(bill.cd).to                       eq 'BILL-1'
        expect(bill.project_name).to             eq project.name
        expect(bill.company_name).to             eq project.billing_company_name
        expect(bill.amount).to                   eq 100_000
        expect(bill.delivery_on.to_s).to         eq '2016-01-01'
        expect(bill.acceptance_on.to_s).to       eq '2016-01-02'
        expect(bill.payment_type).to             eq 'bill_on_15th_and_payment_on_end_of_next_month'
        expect(bill.bill_on.to_s).to             eq '2016-01-04'
        expect(bill.expected_deposit_on.to_s).to eq '2016-01-05'
        expect(bill.memo).to                     eq 'memo'
        expect(bill.status).to                   eq 'unapplied'
        expect(bill.create_user_id).to           eq user.id
      end

      it 'create default detail' do
        post path, params: params

        bill = Bill.first
        expect(bill.details.count).to               eq 1
        expect(bill.details.first.content).to       eq bill.project.name
        expect(bill.details.first.amount).to        eq bill.amount
        expect(bill.details.first.display_order).to eq 1
      end
    end

    context 'with uncorrect parameter' do
      let(:params) do
        {
          bill: {
            cd: '',
            amount:              100_000,
            delivery_on:         '2016-01-01',
            acceptance_on:       '2016-01-02',
            payment_type:        'bill_on_15th_and_payment_on_end_of_next_month',
            bill_on:             '2016-01-04',
            expected_deposit_on: '2016-01-05',
            memo:                'memo',
            create_user_id:      user.id,
          },
        }
      end

      it 'do not create a bill' do
        expect do
          post path, params: params
        end.not_to change(Bill, :count)
      end
    end
  end

  describe 'PATCH /api/bills/:id' do
    subject { patch path, params: params }

    context 'with exist bill id' do
      let(:project) { create(:project) }
      let(:bill)    { create(:bill, project: project) }
      let(:path)    { "/api/bills/#{bill.id}" }

      context 'with correct parameter' do
        let(:params) do
          {
            bill: {
              cd:                  'BILL-1',
              project_name:        'updated_project_name',
              company_name:        'updated_company_name',
              amount:              100_000,
              delivery_on:         '2016-01-01',
              acceptance_on:       '2016-01-02',
              payment_type:        'bill_on_15th_and_payment_on_end_of_next_month',
              bill_on:             '2016-01-04',
              issue_on:            '2016-01-04',
              expected_deposit_on: '2016-01-05',
              deposit_on:          '2016-01-05',
              memo:                'memo',
            },
          }
        end

        it 'update the bill' do
          expect { subject }.to change { bill.reload && bill.updated_at }

          expect(bill.project).to                  eq project
          expect(bill.cd).to                       eq 'BILL-1'
          expect(bill.project_name).to             eq 'updated_project_name'
          expect(bill.company_name).to             eq 'updated_company_name'
          expect(bill.amount).to                   eq 100_000
          expect(bill.delivery_on.to_s).to         eq '2016-01-01'
          expect(bill.acceptance_on.to_s).to       eq '2016-01-02'
          expect(bill.payment_type).to             eq 'bill_on_15th_and_payment_on_end_of_next_month'
          expect(bill.bill_on.to_s).to             eq '2016-01-04'
          expect(bill.issue_on.to_s).to            eq '2016-01-04'
          expect(bill.expected_deposit_on.to_s).to eq '2016-01-05'
          expect(bill.deposit_on.to_s).to          eq '2016-01-05'
          expect(bill.memo).to                     eq 'memo'
          expect(bill.status).to                   eq 'unapplied'
        end

        it 'return success code and message' do
          subject

          expect(response).to be_success
          expect(response.status).to eq 201

          expect(json['id']).not_to eq nil
          expect(json['message']).to eq '請求を更新しました'
        end
      end

      context 'with uncorrect parameter' do
        let(:params) do
          {
            bill: {
              cd: '  ',
              amount:              100_000,
              delivery_on:         '2016-01-01',
              acceptance_on:       '2016-01-02',
              payment_type:        'bill_on_15th_and_payment_on_end_of_next_month',
              bill_on:             '2016-01-04',
              expected_deposit_on: '2016-01-05',
              deposit_on:          '2016-01-05',
              memo:                'memo',
            },
          }
        end

        it 'do not update the bill' do
          expect { subject }.not_to change { bill.reload && bill.updated_at }
        end

        it 'return 422 Unprocessable Entity code and message' do
          subject

          expect(response).not_to be_success
          expect(response.status).to eq 422

          expect(json['message']).to eq '請求が更新できませんでした'
        end
      end

      context 'status is "approved"' do
        let(:params) { { bill: { status: 'issued' } } }

        before { bill.approved_bill! }

        it 'update status to "issued"' do
          subject
          expect(bill.reload.status).to eq "issued"
        end
      end
    end
  end

  describe 'DELETE /api/bills/:id' do
    context 'with exist bill id' do
      let!(:bill) { create(:bill) }
      let(:path) { "/api/bills/#{bill.id}" }

      it 'delete the bill and return the succcess message' do
        expect do
          delete path
        end.to change(Bill, :count).by(-1)

        expect(response).to be_success
        expect(response.status).to eq 201

        expect(flash[:success]).to eq '請求を削除しました'
      end
    end

    context 'with not exist bill id' do
      let!(:bill) { create(:bill) }
      let(:path) { "/api/bills/0" }

      it 'return 404 Not Found code and message' do
        expect do
          delete path
        end.not_to change(Bill, :count)

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end
end
