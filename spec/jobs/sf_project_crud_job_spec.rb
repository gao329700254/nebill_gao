require 'rails_helper'

RSpec.describe SfProjectCrudJob, type: :job do

  let(:nebill_project) { create(:contracted_project) }
  let(:job)            { described_class.new }

  before { Rails.application.secrets.sf_username = 'mock_sf_username' }

  context 'create an sf project' do
    let(:sf_client_mock) { double('sf_client_mock', query: [], create: nil) }

    before { allow(job).to receive(:sf_client).and_return(sf_client_mock) }

    it 'calls client.create() with correct params' do
      job.perform(project_cd: nebill_project.cd, action: 'create_or_update')
      expect(sf_client_mock).to have_received(:create).with(
        SfConstants::SF_PROJECTS,
        SfConstants::SF_NAME                   => nebill_project.name,
        SfConstants::SF_CD                     => nebill_project.cd,
        SfConstants::SF_CONTRACT_ON            => nebill_project.contract_on.to_s,
        SfConstants::SF_END_ON                 => nebill_project.end_on.present? ? nebill_project.end_on.to_s : Time.zone.today.to_s,
        SfConstants::SF_PERIOD_UNIT            => '月',
        SfConstants::SF_MANDAYS_UNIT           => '人時',
        SfConstants::SF_GROSS_MARGIN_RATE_PLAN => 20,
      )
    end
  end

  context 'update an sf project' do
    let(:sf_client_mock) { double('sf_client_mock', query: [{ 'Id' => 'sf_project_id' }], update: nil) }

    before { allow(job).to receive(:sf_client).and_return(sf_client_mock) }

    it 'calls client.update() with correct params' do
      job.perform(project_cd: nebill_project.cd, action: 'create_or_update')
      expect(sf_client_mock).to have_received(:update).with(
        SfConstants::SF_PROJECTS,
        SfConstants::SF_ID                     => 'sf_project_id',
        SfConstants::SF_NAME                   => nebill_project.name,
        SfConstants::SF_CD                     => nebill_project.cd,
        SfConstants::SF_CONTRACT_ON            => nebill_project.contract_on.to_s,
        SfConstants::SF_END_ON                 => nebill_project.end_on.present? ? nebill_project.end_on.to_s : Time.zone.today.to_s,
        SfConstants::SF_PERIOD_UNIT            => '月',
        SfConstants::SF_MANDAYS_UNIT           => '人時',
        SfConstants::SF_GROSS_MARGIN_RATE_PLAN => 20,
      )
    end
  end

  context 'delete an sf project' do
    let(:sf_client_mock) { double('sf_client_mock', query: [{ 'Id' => 'sf_project_id' }], destroy: nil) }

    before { allow(job).to receive(:sf_client).and_return(sf_client_mock) }

    it 'calls client.destroy() with correct params' do
      job.perform(project_cd: nebill_project.cd, action: 'destroy')
      expect(sf_client_mock).to have_received(:destroy).with(SfConstants::SF_PROJECTS, 'sf_project_id')
    end
  end
end
