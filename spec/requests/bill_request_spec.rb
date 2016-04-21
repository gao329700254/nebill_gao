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

    it 'return a list of bills' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 4

      expect(json[0]['id']).to             eq bill1.id
      expect(json[0]['project_id']).to     eq bill1.project_id
      expect(json[0]['key']).to            eq bill1.key
      expect(json[0]['delivery_on']).to    eq bill1.delivery_on.strftime("%Y-%m-%d")
      expect(json[0]['acceptance_on']).to  eq bill1.acceptance_on.strftime("%Y-%m-%d")
      expect(json[0]['payment_type']).to   eq bill1.payment_type
      expect(json[0]['payment_on']).to     eq bill1.payment_on.strftime("%Y-%m-%d")
      expect(json[0]['bill_on']).to        eq bill1.bill_on ? bill1.bill_on.strftime("%Y-%m-%d") : nil
      expect(json[0]['deposit_on']).to     eq bill1.deposit_on ? bill1.deposit_on.strftime("%Y-%m-%d") : nil
      expect(json[0]['created_at']).to     eq bill1.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      expect(json[0]['updated_at']).to     eq bill1.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    end
  end
end
