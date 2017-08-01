require 'rails_helper'

RSpec.describe Admin::PagesController do

  subject { response }

  describe 'GET #users' do
    context 'when not logged in' do
      before { get :users }

      it { is_expected.to redirect_to root_path }
    end

    context 'when logged in' do
      context 'with admin user' do
        let(:admin_user) { create(:admin_user) }
        before { login(admin_user) }
        before { get :users }

        it { is_expected.to render_template :users }
      end
    end
  end
end
