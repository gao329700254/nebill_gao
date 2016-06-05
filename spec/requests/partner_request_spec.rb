require 'rails_helper'

RSpec.describe 'partners request' do
  let!(:user) { create(:user) }

  before { login(user) }

  describe 'POST /api/partners' do
    let(:path) { '/api/partners' }

    context 'with correct parameter' do
      let(:params) do
        {
          partner: {
            name: 'foo bar',
            email: 'foo@example.com',
            company_name: 'hoge company',
          },
        }
      end

      it 'create a partner' do
        expect do
          post path, params
        end.to change(Partner, :count).by(1)

        partner = Partner.first
        expect(partner.name).to         eq 'foo bar'
        expect(partner.email).to        eq 'foo@example.com'
        expect(partner.company_name).to eq 'hoge company'
      end
    end

    context 'with uncorrect parameter' do
      let(:params) do
        {
          partner: {
            name: 'foo bar',
            email: 'foo@example',
            company_name: 'hoge company',
          },
        }
      end

      it 'do not create a partner' do
        expect do
          post path, params
        end.not_to change(Partner, :count)
      end
    end
  end
end
