require 'rails_helper'

RSpec.describe 'project file groups request' do
  let!(:user) { create(:user) }
  let!(:project) { create(:contracted_project) }

  before { login(user) }

  describe 'GET /api/projects/:project_id/project_file_groups' do
    let!(:project_file_group) { create_list(:project_file_group, 3, project: project) }
    let(:path) { "/api/projects/#{project.id}/project_file_groups" }

    it 'return a list of project file groups' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 3

      json0 = json[0]
      expect(json0).to have_key 'id'
      expect(json0).to have_key 'name'
      expect(json0).to have_key 'created_at'
      expect(json0).to have_key 'updated_at'
    end
  end

  describe 'POST /api/project_groups' do
    let(:path) { "/api/projects/#{project.id}/project_file_groups" }
    let(:params) { { project_file_group: { name: 'name' } } }

    it 'create a project file group' do
      expect do
        post path, params
      end.to change(ProjectFileGroup, :count).by(1)

      project_file_group = ProjectFileGroup.first
      expect(project_file_group.name).to eq 'name'
    end

    it 'return success code and message' do
      post path, params

      expect(response).to be_success
      expect(response.status).to eq 201

      expect(json['id']).not_to eq nil
      expect(json['message']).to eq 'プロジェクトファイルグループを作成しました'
    end
  end
end
