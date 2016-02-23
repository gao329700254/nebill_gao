require 'rails_helper'

RSpec.describe 'project groups request' do
  describe 'GET /api/project_groups' do
    let!(:project_group1) { create(:project_group) }
    let!(:project_group2) { create(:project_group) }
    let!(:project_group3) { create(:project_group) }
    let(:path) { "/api/project_groups" }

    it 'return a list of project groups' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 3

      expect(json[0]['name']).to eq project_group1.name
    end
  end

  describe 'POST /api/project_groups' do
    let(:path) { "/api/project_groups" }

    context 'with correct parameter' do
      let(:params) { { project_group: { name: 'name' } } }

      it 'create a project group' do
        expect do
          post path, params
        end.to change(ProjectGroup, :count).by(1)

        project_group = ProjectGroup.first
        expect(project_group.name).to eq  'name'
      end

      it 'return success code and message' do
        post path, params

        expect(response).to be_success
        expect(response.status).to eq 201

        expect(json['id']).not_to eq nil
        expect(json['message']).to eq 'プロジェクトグループを作成しました'
      end
    end

    context 'with uncorrect parameter' do
      let(:params) { { project_group: { name: '  ' } } }

      it 'do not create a project group' do
        expect do
          post path, params
        end.not_to change(ProjectGroup, :count)
      end

      it 'return 422 Unprocessable Entity code and message' do
        post path, params

        expect(response).not_to be_success
        expect(response.status).to eq 422

        expect(json['message']).to eq 'プロジェクトグループが作成できませんでした'
      end
    end
  end

  describe 'PATCH /api/project_groups' do
    context 'with exist project group id' do
      let(:project_group) { create(:project_group) }
      let(:path) { "/api/project_groups/#{project_group.id}" }

      context 'with correct parameter' do
        let(:params) { { project_group: { name: 'name' } } }

        it 'update the project group' do
          expect do
            patch path, params
          end.to change { project_group.reload && project_group.updated_at }

          expect(project_group.name).to eq 'name'
        end

        it 'return success code and message' do
          patch path, params

          expect(response).to be_success
          expect(response.status).to eq 201

          expect(json['id']).not_to eq nil
          expect(json['message']).to eq 'プロジェクトグループを更新しました'
        end
      end

      context 'with uncorrect parameter' do
        let(:params) { { project_group: { name: '  ' } } }

        it 'do not update the project group' do
          expect do
            patch path, params
          end.not_to change { project_group.reload && project_group.updated_at }
        end

        it 'return 422 Unprocessable Entity code and message' do
          patch path, params

          expect(response).not_to be_success
          expect(response.status).to eq 422

          expect(json['message']).to eq 'プロジェクトグループが更新できませんでした'
        end
      end
    end

    context 'with not exist project group id' do
      let(:path) { '/api/projects/0' }

      it 'return 404 Not Found code and message' do
        patch path

        expect(response).not_to be_success
        expect(response.status).to eq 404

        expect(json['message']).to eq 'リソースが見つかりませんでした'
      end
    end
  end
end
