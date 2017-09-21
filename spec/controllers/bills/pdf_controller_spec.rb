require 'rails_helper'

RSpec.describe Bills::PdfController do
  subject { response }

  describe 'GET #pdf' do
    let(:project) { create(:project) }
    let(:bill) { create(:bill, project: project) }

    context 'when not logged in' do
      before { get :download, bill_id: bill.id }

      it { is_expected.to redirect_to root_path }
    end
    context 'when logged in' do
      let(:user) { create(:user) }
      let(:file_name) { ['請求書', bill.project.billing_company_name, bill.cd].compact.join("_") + '.pdf' }

      before { login(user) }
      before { get :download, bill_id: bill.id }

      it "succeed file download" do
        expect(response).to be_success
        expect(response.headers['Content-Disposition']).to include(file_name)
        expect(response.content_type).to eq('application/pdf')
      end
    end
  end
end
