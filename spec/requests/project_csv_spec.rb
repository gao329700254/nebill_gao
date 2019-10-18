require 'rails_helper'

RSpec.describe 'projects download csv' do
  include_context 'logged_in_user'

  describe 'GET /projects/csv' do
    subject { get path, params: params }

    let(:path) { '/projects/csv' }
    let(:csv)  { CSV.parse(response.body, headers: :first_row) }

    context 'search by contracted' do
      let!(:contracted_project)   { create(:contracted_project) }
      let!(:uncontracted_project) { create(:uncontracted_project) }

      it 'return corresponding projects' do
        contract_status_and_expected_cds =
          {
            'all_contract_type': [contracted_project.cd, uncontracted_project.cd],
            'contracted':        [contracted_project.cd],
            'uncontracted':      [uncontracted_project.cd],
          }

        contract_status_and_expected_cds.each do |contract_status, cds|
          params = { contract_status: contract_status }
          get path, params: params
          expect(csv.map { |line| line[1] }).to include(*cds)
        end
      end
    end

    context 'search by status and unprocessed' do
      let!(:progress_project) { create(:project, status: :receive_order) }
      let!(:finished_project)     { create(:project, status: :finished) }
      let!(:unprocessed_finished_project)  { create(:project, unprocessed: true, status: :finished) }

      it 'return corresponding projects' do
        status_and_expected_cds =
          {
            'all_pjt_status': [progress_project.cd, finished_project.cd, unprocessed_finished_project.cd],
            'progress':       [progress_project.cd],
            'finished':       [finished_project.cd, unprocessed_finished_project.cd],
            'unprocessed':    [unprocessed_finished_project.cd],
          }

        status_and_expected_cds.each do |status, cds|
          params = { status: status }
          get path, params: params
          expect(csv.map { |line| line[1] }).to include(*cds)
        end
      end
    end

    context 'search by start_on' do
      let!(:hit_project)  { create(:contracted_project, start_on: '2019-10-01') }
      let!(:miss_project) { create(:contracted_project, start_on: '2019-09-30') }
      let(:params)        { { start: '2019-10-01' } }

      before { subject }
      it 'returns hit project' do
        expect(csv[0][1]).to eq hit_project.cd
      end
    end

    context 'search by end_on' do
      let!(:hit_project)  { create(:contracted_project, end_on: '2019-09-30') }
      let!(:miss_project) { create(:contracted_project, end_on: '2019-10-01') }
      let(:params)        { { end: '2019-09-30' } }

      before { subject }
      it 'returns hit project' do
        expect(csv[0][1]).to eq hit_project.cd
      end
    end

    context 'search with mixed params' do
      let!(:hit_project)  { create(:contracted_project, status: :receive_order, start_on: '2019-09-30', end_on: '2019-10-01') }
      let!(:miss_project) { create(:uncontracted_project) }
      let(:params)        { { contract_status: 'contracted', status: 'progress', start: '2019-09-30', end: '2019-10-01' } }

      before { subject }
      it 'returns hit project' do
        expect(csv.size).to  eq 1
        expect(csv[0][0]).to eq I18n.t('page.project_list.project_status.progress')
        expect(csv[0][1]).to eq hit_project.cd
        expect(csv[0][2]).to eq hit_project.name
        expect(csv[0][3]).to eq hit_project.orderer_company_name
        expect(csv[0][4]).to eq hit_project.amount&.to_s(:delimited)
        expect(csv[0][5]).to eq '済'
        expect(csv[0][6]).to eq hit_project.start_on.to_s
        expect(csv[0][7]).to eq hit_project.end_on.to_s
        expect(csv[0][8]).to eq hit_project.memo
      end
    end
  end
end
