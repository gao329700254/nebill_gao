require 'rails_helper'

RSpec.describe 'bill details request' do
  let!(:user) { create(:user) }

  before { login(user) }

  describe 'POST /api/projects/:project_id/bill' do
    subject { post path, params: params }

    let!(:bill) { create(:bill) }
    let(:path)  { "/api/bills/#{bill.id}/bill_details" }
    let(:params) do
      {
        details: {
          "0" => {
            id:      50,
            content: "detail_1",
            amount:  40_000_000,
            display_order: 1,
            bill_id: 177,
          },
          "1" => {
            id:      51,
            content: "detail_2",
            amount:  1234,
            display_order: 2,
            bill_id: 177,
          },
        },
        bill_id: 177,
      }
    end

    context 'add details' do
      it do
        subject

        detail_1 = bill.details.first
        expect(detail_1.content).to eq 'detail_1'
        expect(detail_1.amount).to  eq 40_000_000

        detail_2 = bill.details.second
        expect(detail_2.content).to eq 'detail_2'
        expect(detail_2.amount).to  eq 1234
      end
    end

    context 'delete details' do
      let!(:detail) { create(:bill_detail, content: 'detail', amount: 2000, bill: bill) }
      let(:params) do
        {
          details: {
            "0" => {
              id:      50,
              content: "detail_1",
              amount:  40_000_000,
              display_order: 1,
              bill_id: 177,
            },
          },
          bill_id: 177,
        }
      end

      it do
        expect(bill.details.count).to eq 1
      end

      it 'delete one detail' do
        subject
        expect(bill.details.count).to eq 1

        detail = bill.details.first
        expect(detail.content).to eq 'detail_1'
        expect(detail.amount).to  eq 40_000_000
      end
    end
  end
end
