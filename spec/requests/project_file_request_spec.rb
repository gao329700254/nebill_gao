require 'rails_helper'

RSpec.describe 'project files request' do
  let!(:user) { create(:user) }
  let!(:project) { create(:contracted_project) }

  before { login(user) }

  describe 'GET /api/projects/:project_id/project_files' do
    let!(:project_files) { create_list(:project_file, 3, project: project) }
    let(:path) { "/api/projects/#{project.id}/project_files.json" }

    it 'return a list of project files' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 3

      json0 = json[0]
      expect(json0).to have_key 'id'
      expect(json0).to have_key 'original_filename'
      expect(json0).to have_key 'size'
      expect(json0).to have_key 'group'
      expect(json0).to have_key 'created_at'
      expect(json0).to have_key 'updated_at'
    end
  end

  describe 'GET /api/project_files/:id' do
    let!(:file_path) { Rails.root.join('spec/fixtures/sample.jpg') }
    let!(:project_file) { create(:project_file, project: project, file: fixture_file_upload(file_path, 'image/jpg')) }
    let(:path) { "/api/project_files/#{project_file.id}" }

    it 'download the file' do
      get path

      expect(response.body).to eq IO.binread(file_path)
    end
  end

  describe 'POST /api/projects/:project_id/project_files' do
    let(:path) { "/api/projects/#{project.id}/project_files" }

    let(:params) do
      {
        file: fixture_file_upload(Rails.root.join('spec/fixtures/sample.jpg'), 'image/jpg'),
      }
    end

    it 'create a project file' do
      expect do
        post path, params
      end.to change(ProjectFile, :count).by(1)

      project_file = ProjectFile.first
      expect(project_file.original_filename).to eq 'sample.jpg'
    end

    it 'return success code and message' do
      post path, params

      expect(response).to be_success
      expect(response.status).to eq 201

      expect(json['id']).not_to eq nil
      expect(json['message']).to eq 'sample.jpgをアップロードしました'
    end
  end

  describe 'PATCH /api/project_files/:id' do
    let!(:project_file_group) { create(:project_file_group) }
    let!(:project_file) { create(:project_file, project: project) }
    let(:path) { "/api/project_files/#{project_file.id}" }
    let(:params) { { project_file: { file_group_id: project_file_group.id } } }

    it 'update the project file' do
      expect do
        patch path, params
      end.to change { project_file.reload && project_file.updated_at }

      expect(project_file.group).to eq project_file_group
    end

    it 'return success code and message' do
      patch path, params

      expect(response).to be_success
      expect(response.status).to eq 201

      expect(json['id']).not_to eq nil
      expect(json['message']).to eq 'プロジェクトファイルを更新しました'
    end
  end

  describe 'DELETE /api/project_files/:id' do
    context 'with exist project_file' do
      let!(:project_file) { create(:project_file, project: project) }
      let(:path) { "/api/project_files/#{project_file.id}" }

      it 'delete the project fileand return success message' do
        expect do
          delete path
        end.to change(ProjectFile, :count).by(-1)

        expect(response).to be_success
        expect(response.status).to eq 201

        expect(json['message']).to eq 'プロジェクトファイルを削除しました'
      end
    end

    context 'with not exist project_file' do
      let(:path) { "/api/project_files/0" }

      it 'return 404 Not Found code and message' do
        expect do
          delete path
        end.not_to change(ProjectFile, :count)

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end
end
