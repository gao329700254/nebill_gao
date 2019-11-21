require 'rails_helper'

RSpec.describe 'bill_issueds request' do
  let!(:admin_user) { create(:admin_user) }

  before { login(admin_user) }

  describe "GET /api/bill_issueds" do
    let!(:bill1) { create(:bill) }
    let!(:bill2) { create(:bill, status: 'approved') }
    let!(:bill3) { create(:bill, status: 'issued', deposit_confirmed_memo: 'deposit_confirmed_memo') }
    let!(:bill4) { create(:bill, status: 'confirmed', deposit_on: '2019-11-21') }
    let(:path)   { "/api/bill_issueds" }

    it 'return a list of bill_issueds and projects that belong to the bill' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 2

      expect(json[0]['id']).to                               eq bill3.id
      expect(json[0]['project_id']).to                       eq bill3.project_id
      expect(json[0]['cd']).to                               eq bill3.cd
      expect(json[0]['amount']).to                           eq bill3.amount
      expect(json[0]['delivery_on']).to                      eq bill3.delivery_on.strftime("%Y-%m-%d")
      expect(json[0]['acceptance_on']).to                    eq bill3.acceptance_on.strftime("%Y-%m-%d")
      expect(json[0]['payment_type']).to                     eq I18n.t("enumerize.defaults.payment_type.#{bill3.payment_type}")
      expect(json[0]['bill_on']).to                          eq bill3.bill_on.strftime("%Y-%m-%d")
      expect(json[0]['expected_deposit_on']).to              eq bill3.expected_deposit_on.strftime("%Y-%m-%d")
      expect(json[0]['deposit_on']).to                       eq nil
      expect(json[0]['memo']).to                             eq bill3.memo
      expect(json[0]['deposit_confirmed_memo']).to           eq bill3.deposit_confirmed_memo
      expect(json[0]['status']).to                           eq bill3.status_i18n
      expect(json[0]['created_at']).to                       eq bill3.created_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
      expect(json[0]['updated_at']).to                       eq bill3.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
      expect(json[0]['project']['name']).to                  eq bill3.project.name
      expect(json[0]['project']['billing_company_name']).to  eq bill3.project.billing_company_name

    end
  end

  describe 'PATCH /api/bills/:id' do
    subject { patch path, params: params }

    context 'with exist bill id' do
      let(:project) { create(:project) }
      let(:bill)    { create(:bill, status: 'issued', project: project) }
      let(:path)    { "/api/bill_issueds/#{bill.id}" }

      context 'with correct parameter' do
        let(:params) do
          {
            bill: {
              status:                 'confirmed',
              deposit_on:             '2019-12-05',
              deposit_confirmed_memo: 'deposit_confirmed_memo',
            },
          }
        end

        it 'update the bill in modal' do

          expect { subject }.to change { bill.reload && bill.updated_at }

          expect(bill.deposit_on.to_s).to          eq '2019-12-05'
          expect(bill.deposit_confirmed_memo).to   eq 'deposit_confirmed_memo'
          expect(bill.status).to                   eq 'confirmed'
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
              status:                 'confirmed',
              deposit_on:             ' ',
              deposit_confirmed_memo: 'deposit_confirmed_memo',
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
    end
  end
end
