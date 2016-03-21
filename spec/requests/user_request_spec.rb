require 'rails_helper'

RSpec.describe 'user request' do
  let!(:admin_user) { create(:admin_user) }

  before { login(admin_user) }

  describe 'POST /api/users' do
    let(:path) { "/api/users" }

    context 'with correct parameter' do
      let(:params) { { user: { email: 'foo@example.com' } } }

      it 'create a user' do
        expect do
          post path, params
        end.to change(User, :count).by(1)

        user = User.last
        expect(user.email).to eq 'foo@example.com'
      end

      it 'return success code and message' do
        post path, params

        expect(response).to be_success
        expect(response.status).to eq 201

        expect(json['id']).not_to eq nil
        expect(json['message']).to eq 'ユーザを作成しました'
      end
    end

    context 'with uncorrect parameter' do
      let(:params) { { user: { email: '  ' } } }

      it 'do not create a project group' do
        expect do
          post path, params
        end.not_to change(User, :count)
      end

      it 'return 422 Unprocessable Entity code and message' do
        post path, params

        expect(response).not_to be_success
        expect(response.status).to eq 422

        expect(json['message']).to eq 'ユーザが作成できませんでした'
      end
    end
  end

end
