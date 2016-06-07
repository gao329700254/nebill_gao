require 'rails_helper'

RSpec.describe 'partner request' do
  let!(:user) { create(:user) }

  before { login(user) }

  describe 'GET /api/partners' do
    let!(:partner1) { create(:partner) }
    let!(:partner2) { create(:partner) }
    let!(:partner3) { create(:partner) }
    let(:path) { '/api/partners' }

    it 'return a list of partners' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 3

      expect(json[0]['id']).to           eq partner1.id
      expect(json[0]['name']).to         eq partner1.name
      expect(json[0]['email']).to        eq partner1.email
      expect(json[0]['company_name']).to eq partner1.company_name
      expect(json[0]['created_at']).to   eq partner1.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      expect(json[0]['updated_at']).to   eq partner1.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    end
  end

  describe 'GET /api/projects/:project_id/partners' do
    let!(:partner1) { create(:partner, :with_project, project: project) }
    let!(:partner2) { create(:partner, :with_project, project: project) }
    let!(:partner3) { create(:partner, :with_project, project: project) }
    let(:project) { create(:contracted_project) }
    let(:path) { "/api/projects/#{project.id}/partners" }

    it 'return a list of partners' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 3

      json.sort_by! { |x| x['id'].to_i }

      expect(json[0]['id']).to           eq partner1.id
      expect(json[0]['name']).to         eq partner1.name
      expect(json[0]['email']).to        eq partner1.email
      expect(json[0]['company_name']).to eq partner1.company_name
      expect(json[0]['created_at']).to   eq partner1.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      expect(json[0]['updated_at']).to   eq partner1.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    end
  end
end
