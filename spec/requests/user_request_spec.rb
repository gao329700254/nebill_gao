require 'rails_helper'

RSpec.describe 'user request' do
  let!(:admin_user) { create(:admin_user) }

  before { login(admin_user) }

  describe 'GET /api/users' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }
    let(:path) { '/api/users' }

    it 'return a list of users' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 4

      expect(json[0]['id']).to         eq admin_user.id
      expect(json[0]['name']).to       eq admin_user.name
      expect(json[0]['email']).to      eq admin_user.email
      expect(json[0]['role']).to       eq admin_user.role
      expect(json[0]['is_admin']).to   eq admin_user.is_admin
      expect(json[0]['created_at']).to eq admin_user.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      expect(json[0]['updated_at']).to eq admin_user.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    end
  end

  describe 'GET /api/projects/:project_id/users' do
    context 'with exist project id' do
      let(:project) { create(:contracted_project) }
      let(:bill) { create(:bill, project: project) }
      let!(:user1) { create(:user, :with_bill, bill: bill) }
      let!(:user2) { create(:user, :with_bill, bill: bill) }
      let!(:user3) { create(:user, :with_bill, bill: bill) }
      let(:path) { "/api/projects/#{project.id}/users" }

      it 'return a list of users' do
        get path

        expect(response).to be_success
        expect(response.status).to eq 200
        expect(json.count).to eq 3

        json.sort_by! { |x| x['id'].to_i }

        expect(json[0]['id']).to         eq user1.id
        expect(json[0]['name']).to       eq user1.name
        expect(json[0]['email']).to      eq user1.email
        expect(json[0]['role']).to       eq user1.role
        expect(json[0]['is_admin']).to   eq user1.is_admin
        expect(json[0]['created_at']).to eq user1.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
        expect(json[0]['updated_at']).to eq user1.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")

        expect(json[1]['id']).to         eq user2.id
        expect(json[1]['name']).to       eq user2.name
        expect(json[1]['email']).to      eq user2.email
        expect(json[1]['role']).to       eq user2.role
        expect(json[1]['is_admin']).to   eq user2.is_admin
        expect(json[1]['created_at']).to eq user2.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
        expect(json[1]['updated_at']).to eq user2.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")

        expect(json[2]['id']).to         eq user3.id
        expect(json[2]['name']).to       eq user3.name
        expect(json[2]['email']).to      eq user3.email
        expect(json[2]['role']).to       eq user3.role
        expect(json[2]['is_admin']).to   eq user3.is_admin
        expect(json[2]['created_at']).to eq user3.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
        expect(json[2]['updated_at']).to eq user3.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      end
    end

    context 'with not exist project id' do
      let(:path) { '/api/projects/0/users' }

      it 'return 404 Not Found code and message' do
        get path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end

  describe 'GET /api/bills/:bill_id/users' do
    context 'with exist project id' do
      let(:bill) { create(:bill) }
      let!(:user1) { create(:user, :with_bill, bill: bill) }
      let!(:user2) { create(:user, :with_bill, bill: bill) }
      let!(:user3) { create(:user, :with_bill, bill: bill) }
      let(:path) { "/api/bills/#{bill.id}/users" }

      it 'return a list of bill_users' do
        get path

        expect(response).to be_success
        expect(response.status).to eq 200
        expect(json.count).to eq 3

        json.sort_by! { |x| x['id'].to_i }

        expect(json[0]['id']).to         eq user1.id
        expect(json[0]['name']).to       eq user1.name
        expect(json[0]['email']).to      eq user1.email
        expect(json[0]['role']).to       eq user1.role
        expect(json[0]['is_admin']).to   eq user1.is_admin
        expect(json[0]['created_at']).to eq user1.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
        expect(json[0]['updated_at']).to eq user1.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")

        expect(json[1]['id']).to         eq user2.id
        expect(json[1]['name']).to       eq user2.name
        expect(json[1]['email']).to      eq user2.email
        expect(json[1]['role']).to       eq user2.role
        expect(json[1]['is_admin']).to   eq user2.is_admin
        expect(json[1]['created_at']).to eq user2.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
        expect(json[1]['updated_at']).to eq user2.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")

        expect(json[2]['id']).to         eq user3.id
        expect(json[2]['name']).to       eq user3.name
        expect(json[2]['email']).to      eq user3.email
        expect(json[2]['role']).to       eq user3.role
        expect(json[2]['is_admin']).to   eq user3.is_admin
        expect(json[2]['created_at']).to eq user3.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
        expect(json[2]['updated_at']).to eq user3.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      end
    end

    context 'with not exist bill id' do
      let(:path) { '/api/bills/0/users' }

      it 'return 404 Not Found code and message' do
        get path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end

  describe 'POST /api/users' do
    let(:path) { "/api/users" }

    context 'with correct parameter' do
      let(:params) { { user: { email: 'foo@example.com', role: 30 } } }

      it 'create a user' do
        expect do
          post path, params
        end.to change(User, :count).by(1)

        user = User.last
        expect(user.email).to eq 'foo@example.com'
        expect(user.role).to eq 'superior'
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
