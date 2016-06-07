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
      expect(json[0]['is_admin']).to   eq admin_user.is_admin
      expect(json[0]['created_at']).to eq admin_user.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      expect(json[0]['updated_at']).to eq admin_user.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    end
  end

  describe 'GET /api/projects/:project_id/users' do
    let!(:user1) { create(:user, :with_project, project: project) }
    let!(:user2) { create(:user, :with_project, project: project) }
    let!(:user3) { create(:user, :with_project, project: project) }
    let(:project) { create(:contracted_project) }
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
      expect(json[0]['is_admin']).to   eq user1.is_admin
      expect(json[0]['created_at']).to eq user1.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      expect(json[0]['updated_at']).to eq user1.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    end
  end

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
