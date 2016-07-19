require 'rails_helper'

RSpec.describe UserSessionsController do

  subject { response }

  describe 'POST #create' do
    context 'with un registered user' do
      let!(:un_register_user) { create(:un_register_user, email: 'alice@example.com') }
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
          provider: 'google_oauth2',
          uid: '012345678901234567890',
          info: { email: 'alice@example.com', name: 'alice' },
        )
        post :create, provider: 'google_oauth2'
        un_register_user.reload
      end

      it 'should register user info' do
        expect(un_register_user.provider).to eq 'google_oauth2'
        expect(un_register_user.uid).to      eq '012345678901234567890'
        expect(un_register_user.name).to     eq 'alice'
      end

      it 'should login' do
        expect(controller.session['user_credentials']).to eq un_register_user.persistence_token
      end
      it { is_expected.to redirect_to project_list_path }
    end

    context 'with registered user' do
      let!(:user) { create(:user, provider: 'google_oauth2', uid: '012345678901234567890') }
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
          provider: 'google_oauth2',
          uid: '012345678901234567890',
          info: { email: 'alice@example.com', name: 'alice' },
        )
        post :create, provider: 'google_oauth2'
      end
      it 'should login' do
        expect(controller.session['user_credentials']).to eq user.persistence_token
      end
      it { is_expected.to redirect_to project_list_path }
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    before { login(user) }
    before { delete :destroy }

    it 'should logout' do
      expect(controller.session['user_credentials']).to be_nil
    end
    it { is_expected.to redirect_to root_path }
  end
end
