# require 'rails_helper'

# RSpec.describe Sf::CrudWorkItemService do
#   subject { service.execute }
#   let(:nebill_project) { create(:contracted_project, contract_on: project_contract_on, end_on: project_end_on) }
#   let(:project_contract_on) { Date.parse('2019-01-01') }
#   let(:project_end_on)      { Date.parse('2019-03-01') }
#   let(:user_member0)   { create(:user_member, project: nebill_project) }
#   let(:user_member1)   { create(:user_member, project: nebill_project) }
#   let(:service)        { described_class.new(params) }
#   let(:client_mock)    { double('client_mock', create: nil, destroy: nil) }
#   let(:work_item_info) do
#     {
#       user_member0.user.name => {
#         resource_id:   'user_member0_resource_id',
#         rank_id:       'user_member0_rank_id',
#       },
#       user_member1.user.name => {
#         resource_id:   'user_member1_resource_id',
#         rank_id:       'user_member1_rank_id',
#       },
#     }
#   end
#   let(:sf_project_details) do
#     [
#       { 'Id' => 'sf_pd0', SfConstants::SF_PROJECTDETAIL_START_DATE.to_s => '2019-01-01' },
#       { 'Id' => 'sf_pd1', SfConstants::SF_PROJECTDETAIL_START_DATE.to_s => '2019-02-01' },
#       { 'Id' => 'sf_pd2', SfConstants::SF_PROJECTDETAIL_START_DATE.to_s => '2019-03-01' },
#     ]
#   end

#   before do
#     allow_any_instance_of(described_class).to receive(:initialize).and_return(nil)
#     service.instance_variable_set(:@params, params)
#     service.instance_variable_set(:@nebill_project, nebill_project)
#     service.instance_variable_set(:@sf_project_id, 'sf_project_id')
#     service.instance_variable_set(:@sf_project_start_date, project_contract_on)
#     service.instance_variable_set(:@sf_project_end_date, project_end_on)
#     service.instance_variable_set(:@sf_project_details, sf_project_details)
#     service.instance_variable_set(:@work_item_info, work_item_info)
#     allow(service).to receive(:client).and_return(client_mock)
#   end

#   context 'create work items' do
#     let(:params) do
#       {
#         project_cd: nebill_project.cd,
#         user_names: [user_member0.user.name, user_member1.user.name],
#         action: 'create_project',
#       }
#     end
#     let(:user_member0_work_item_params) do
#       [
#         SfConstants::SF_WORKITEMS,
#         SfConstants::SF_WORKITEM_PROJECT_ID => 'sf_project_id',
#         SfConstants::SF_WORKITEM_NAME       => user_member0.user.name,
#       ]
#     end
#     let(:user_member1_work_item_params) do
#       [
#         SfConstants::SF_WORKITEMS,
#         SfConstants::SF_WORKITEM_PROJECT_ID => 'sf_project_id',
#         SfConstants::SF_WORKITEM_NAME       => user_member1.user.name,
#       ]
#     end

#     before do
#       allow(client_mock).to receive(:create).with(*user_member0_work_item_params).and_return('user_member0_work_item_id')
#       allow(client_mock).to receive(:create).with(*user_member1_work_item_params).and_return('user_member1_work_item_id')
#       subject
#     end

#     it 'calls client.create() with correct params' do
#       expect(client_mock).to have_received(:create).with(*user_member0_work_item_params).once

#       3.times do |index|
#         expect(client_mock).to have_received(:create).with(
#           SfConstants::SF_WORKITEMDETAILS,
#           SfConstants::SF_WORKITEMDETAIL_WORKITEM_ID       => 'user_member0_work_item_id',
#           SfConstants::SF_WORKITEMDETAIL_START_DATE        => project_contract_on.next_month(index).to_s,
#           SfConstants::SF_WORKITEMDETAIL_END_DATE          => project_contract_on.next_month(index).end_of_month.to_s,
#           SfConstants::SF_WORKITEMDETAIL_RESOURCE_ID       => 'user_member0_resource_id',
#           SfConstants::SF_WORKITEMDETAIL_RANK_ID           => 'user_member0_rank_id',
#           SfConstants::SF_WORKITEMDETAIL_PROJECT_DETAIL_ID => sf_project_details[index]['Id'],
#         ).once
#       end

#       expect(client_mock).to have_received(:create).with(*user_member1_work_item_params).once

#       3.times do |index|
#         expect(client_mock).to have_received(:create).with(
#           SfConstants::SF_WORKITEMDETAILS,
#           SfConstants::SF_WORKITEMDETAIL_WORKITEM_ID       => 'user_member1_work_item_id',
#           SfConstants::SF_WORKITEMDETAIL_START_DATE        => project_contract_on.next_month(index).to_s,
#           SfConstants::SF_WORKITEMDETAIL_END_DATE          => project_contract_on.next_month(index).end_of_month.to_s,
#           SfConstants::SF_WORKITEMDETAIL_RESOURCE_ID       => 'user_member1_resource_id',
#           SfConstants::SF_WORKITEMDETAIL_RANK_ID           => 'user_member1_rank_id',
#           SfConstants::SF_WORKITEMDETAIL_PROJECT_DETAIL_ID => sf_project_details[index]['Id'],
#         ).once
#       end
#     end
#   end

#   context 'destroy work items' do
#     let(:params) do
#       {
#         project_cd: nebill_project.cd,
#         user_names: [user_member0.user.name],
#         action: 'destroy_work_item',
#       }
#     end
#     let(:work_item_info) do
#       {
#         user_member0.user.name => {
#           resource_id:   'user_member0_resource_id',
#           rank_id:       'user_member0_rank_id',
#           work_item_id:  'user_member0_work_item_id',
#         },
#       }
#     end

#     before do
#       service.instance_variable_set(:@work_item_info, work_item_info)
#       service.instance_variable_set(:@work_item_id, 'user_member0_work_item_id')
#       subject
#     end

#     it 'calls client.destroy() with correct params' do
#       expect(client_mock).to have_received(:destroy).with(SfConstants::SF_WORKITEMS, 'user_member0_work_item_id')
#     end
#   end
# end
