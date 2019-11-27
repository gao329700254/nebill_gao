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
            id:            50,
            content:       "detail_1",
            amount:        40_000_000,
            display_order: 1,
            bill_id:       177,
          },
          "1" => {
            id:            51,
            content:       "detail_2",
            amount:        1234,
            display_order: 2,
            bill_id:       177,
          },
        },
        bill_id: 177,
      }
    end

    context 'create details' do
      it do
        subject

        detail_1 = bill.reload.details.first
        expect(detail_1.content).to       eq 'detail_1'
        expect(detail_1.amount).to        eq 40_000_000
        expect(detail_1.display_order).to eq 1

        detail_2 = bill.reload.details.second
        expect(detail_2.content).to       eq 'detail_2'
        expect(detail_2.display_order).to eq 2
      end
    end
  end
end
