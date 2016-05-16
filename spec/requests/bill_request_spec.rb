require 'rails_helper'

RSpec.describe 'bills request' do
  let!(:user) { create(:user) }

  before { login(user) }

  describe "GET /api/bills" do
    let!(:bill1) { create(:bill) }
    let!(:bill2) { create(:bill) }
    let!(:bill3) { create(:bill) }
    let!(:bill4) { create(:bill) }
    let(:path) { "/api/bills" }

    it 'return a list of bills and projects that belong to the bill' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 4

      expect(json[0]['id']).to                               eq bill1.id
      expect(json[0]['project_id']).to                       eq bill1.project_id
      expect(json[0]['key']).to                              eq bill1.key
      expect(json[0]['delivery_on']).to                      eq bill1.delivery_on.strftime("%Y-%m-%d")
      expect(json[0]['acceptance_on']).to                    eq bill1.acceptance_on.strftime("%Y-%m-%d")
      expect(json[0]['payment_on']).to                       eq bill1.payment_on.strftime("%Y-%m-%d")
      expect(json[0]['bill_on']).to                          eq bill1.bill_on ? bill1.bill_on.strftime("%Y-%m-%d") : nil
      expect(json[0]['deposit_on']).to                       eq bill1.deposit_on ? bill1.deposit_on.strftime("%Y-%m-%d") : nil
      expect(json[0]['memo']).to                             eq bill1.memo
      expect(json[0]['payment_on']).to                       eq bill1.payment_on.strftime("%Y-%m-%d")
      expect(json[0]['bill_on']).to                          eq bill1.bill_on ? bill1.bill_on.strftime("%Y-%m-%d") : nil
      expect(json[0]['deposit_on']).to                       eq bill1.deposit_on ? bill1.deposit_on.strftime("%Y-%m-%d") : nil
      expect(json[0]['created_at']).to                       eq bill1.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      expect(json[0]['updated_at']).to                       eq bill1.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      expect(json[0]['project']['name']).to                  eq bill1.project.name
      expect(json[0]['project']['billing_company_name']).to  eq bill1.project.billing_company_name
      expect(json[0]['project']['amount']).to                eq bill1.project.amount
    end
  end

  describe 'POST /api/projects/:project_id/bill' do
    let(:project) { create(:project) }
    let(:path) { "/api/projects/#{project.id}/bills" }

    context 'with correct parameter' do
      let(:params) do
        {
          bill: {
            key: 'BILL-1',
            delivery_on:   '2016-01-01',
            acceptance_on: '2016-01-02',
            payment_on:    '2016-01-03',
            bill_on:       '2016-01-04',
            deposit_on:    '2016-01-05',
            memo:          'memo',
          },
        }
      end

      it 'create a bill' do
        expect do
          post path, params
        end.to change(Bill, :count).by(1)

        bill = Bill.first
        expect(bill.project).to eq project
        expect(bill.key).to eq 'BILL-1'
        expect(bill.delivery_on.to_s).to    eq '2016-01-01'
        expect(bill.acceptance_on.to_s).to  eq '2016-01-02'
        expect(bill.payment_on.to_s).to     eq '2016-01-03'
        expect(bill.bill_on.to_s).to        eq '2016-01-04'
        expect(bill.deposit_on.to_s).to     eq '2016-01-05'
        expect(bill.memo).to                eq 'memo'
      end
    end

    context 'with uncorrect parameter' do
      let(:params) do
        {
          bill: {
            key: '',
            delivery_on:   '2016-01-01',
            acceptance_on: '2016-01-02',
            payment_on:    '2016-01-03',
            bill_on:       '2016-01-04',
            deposit_on:    '2016-01-05',
            memo:          'memo',
          },
        }
      end

      it 'do not create a bill' do
        expect do
          post path, params
        end.not_to change(Bill, :count)
      end
    end
  end
end
