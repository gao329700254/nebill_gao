# require 'rails_helper'

# RSpec.describe Sf::CrudProjectService do
#   subject { service.execute }
#   let(:nebill_project) { create(:contracted_project) }
#   let(:service)        { described_class.new(params) }
#   let(:client_mock)    { double('client_mock', create: nil, update: nil, destroy: nil) }

#   before do
#     allow_any_instance_of(described_class).to receive(:initialize).and_return(nil)
#     service.instance_variable_set(:@params, params)
#     service.instance_variable_set(:@nebill_project, nebill_project)
#     allow(service).to receive(:client).and_return(client_mock)
#   end

#   context 'create an sf project' do
#     let(:params) { { project_cd: nebill_project.cd, action: 'create_project' } }

#     before { subject }

#     it 'calls client.create() with correct params' do
#       expect(client_mock).to have_received(:create).with(
#         SfConstants::SF_PROJECTS,
#         SfConstants::SF_PROJECT_NAME                   => nebill_project.name,
#         SfConstants::SF_PROJECT_CD                     => nebill_project.cd,
#         SfConstants::SF_PROJECT_START_DATE             => nebill_project.contract_on.to_s,
#         SfConstants::SF_PROJECT_END_DATE               => nebill_project.end_on.present? ? nebill_project.end_on.to_s : Time.zone.today.to_s,
#         SfConstants::SF_PROJECT_PERIOD_UNIT            => '月',
#         SfConstants::SF_PROJECT_MANDAYS_UNIT           => '人時',
#         SfConstants::SF_PROJECT_GROSS_MARGIN_RATE_PLAN => 20,
#       )
#     end
#   end

#   context 'update an sf project' do
#     let(:params) { { project_cd: nebill_project.cd, action: 'update_project' } }

#     before do
#       service.instance_variable_set(:@sf_project_id, 'sf_project_id')
#       subject
#     end

#     it 'calls client.update() with correct params' do
#       expect(client_mock).to have_received(:update).with(
#         SfConstants::SF_PROJECTS,
#         SfConstants::SF_PROJECT_ID                     => 'sf_project_id',
#         SfConstants::SF_PROJECT_NAME                   => nebill_project.name,
#         SfConstants::SF_PROJECT_CD                     => nebill_project.cd,
#         SfConstants::SF_PROJECT_START_DATE             => nebill_project.contract_on.to_s,
#         SfConstants::SF_PROJECT_END_DATE               => nebill_project.end_on.present? ? nebill_project.end_on.to_s : Time.zone.today.to_s,
#         SfConstants::SF_PROJECT_PERIOD_UNIT            => '月',
#         SfConstants::SF_PROJECT_MANDAYS_UNIT           => '人時',
#         SfConstants::SF_PROJECT_GROSS_MARGIN_RATE_PLAN => 20,
#       )
#     end
#   end

#   context 'delete an sf project' do
#     let(:params) { { project_cd: nebill_project.cd, action: 'destroy_project' } }

#     before do
#       service.instance_variable_set(:@sf_project_id, 'sf_project_id')
#       subject
#     end

#     it 'calls client.destroy() with correct params' do
#       expect(client_mock).to have_received(:destroy).with(SfConstants::SF_PROJECTS, 'sf_project_id')
#     end
#   end
# end
