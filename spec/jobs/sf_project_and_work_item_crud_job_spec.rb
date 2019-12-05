require 'rails_helper'

RSpec.describe SfProjectAndWorkItemCrudJob do
  subject                   { job.perform(params) }
  let(:nebill_project)      { create(:contracted_project, contract_on: project_contract_on, end_on: project_end_on) }
  let(:project_contract_on) { Date.parse('2019-01-01') }
  let(:project_end_on)      { Date.parse('2019-03-01') }
  let(:user_member0)        { create(:user_member, project: nebill_project) }
  let(:user_member1)        { create(:user_member, project: nebill_project) }
  let(:job)                 { described_class.new }
  let(:sf_client)           { SfClient.new }
  let(:client_mock)         { double('client_mock', create: nil, update: nil, destroy: nil) }
  let(:work_item_info_hash) do
    {
      user_member0.user.name => {
        resource_id:   'user_member0_resource_id',
        rank_id:       'user_member0_rank_id',
      },
      user_member1.user.name => {
        resource_id:   'user_member1_resource_id',
        rank_id:       'user_member1_rank_id',
      },
    }
  end
  let(:sf_project_info) do
    {
      sf_project_id:         'sf_project_id',
      sf_project_start_date: project_contract_on,
      sf_project_end_date:   project_end_on,
      sf_project_details:    sf_project_details,
    }
  end
  let(:sf_project_details) do
    [
      { 'Id' => 'sf_pd0', SfConstants::SF_PROJECTDETAIL_START_DATE.to_s => '2019-01-01' },
      { 'Id' => 'sf_pd1', SfConstants::SF_PROJECTDETAIL_START_DATE.to_s => '2019-02-01' },
      { 'Id' => 'sf_pd2', SfConstants::SF_PROJECTDETAIL_START_DATE.to_s => '2019-03-01' },
    ]
  end

  before do
    Rails.application.secrets.sf_username = "mock_sf_username"
    allow(job).to receive(:sf_client).and_return(sf_client)
    allow(sf_client).to receive(:client).and_return(client_mock)

    job.instance_variable_set(:@sf_project_info, sf_project_info)
    job.instance_variable_set(:@work_item_info_hash, work_item_info_hash)
  end

  context 'action == create_or_update_project' do
    context 'sf_project_id is blank' do
      let(:params) do
        {
          project_cd: nebill_project.cd,
          user_members_name: [user_member0.user.name, user_member1.user.name],
          action: 'create_or_update_project',
        }
      end
      let(:create_sf_project_params) do
        [
          SfConstants::SF_PROJECTS,
          SfConstants::SF_PROJECT_NAME                   => nebill_project.name,
          SfConstants::SF_PROJECT_CD                     => nebill_project.cd,
          SfConstants::SF_PROJECT_START_DATE             => nebill_project.contract_on.to_s,
          SfConstants::SF_PROJECT_END_DATE               => nebill_project.end_on.present? ? nebill_project.end_on.to_s : Time.zone.today.to_s,
          SfConstants::SF_PROJECT_PERIOD_UNIT            => '月',
          SfConstants::SF_PROJECT_MANDAYS_UNIT           => '人時',
          SfConstants::SF_PROJECT_GROSS_MARGIN_RATE_PLAN => 20,
        ]
      end
      let(:create_user_member0_work_item_params) do
        [
          SfConstants::SF_WORKITEMS,
          SfConstants::SF_WORKITEM_PROJECT_ID => 'sf_project_id',
          SfConstants::SF_WORKITEM_NAME       => user_member0.user.name,
        ]
      end
      let(:create_user_member1_work_item_params) do
        [
          SfConstants::SF_WORKITEMS,
          SfConstants::SF_WORKITEM_PROJECT_ID => 'sf_project_id',
          SfConstants::SF_WORKITEM_NAME       => user_member1.user.name,
        ]
      end

      before do
        received_count = 0
        allow_any_instance_of(SfProjectAndWorkItemCrudJob).to receive(:sf_project_info) do
          if received_count.zero?
            received_count += 1
            job.instance_variable_set(:@sf_project_info, nil)
          else
            job.instance_variable_set(:@sf_project_info, sf_project_info)
          end
        end

        allow(client_mock).to receive(:create).with(*create_user_member0_work_item_params).and_return('user_member0_work_item_id')
        allow(client_mock).to receive(:create).with(*create_user_member1_work_item_params).and_return('user_member1_work_item_id')

        subject
      end

      example 'The sf_client calls client.create() with correct params to create an sf project and work items' do
        expect(client_mock).to have_received(:create).with(*create_sf_project_params).once

        expect(client_mock).to have_received(:create).with(*create_user_member0_work_item_params).once
        3.times do |index|
          expect(client_mock).to have_received(:create).with(
            SfConstants::SF_WORKITEMDETAILS,
            SfConstants::SF_WORKITEMDETAIL_WORKITEM_ID       => 'user_member0_work_item_id',
            SfConstants::SF_WORKITEMDETAIL_START_DATE        => project_contract_on.next_month(index).to_s,
            SfConstants::SF_WORKITEMDETAIL_END_DATE          => project_contract_on.next_month(index).end_of_month.to_s,
            SfConstants::SF_WORKITEMDETAIL_RESOURCE_ID       => 'user_member0_resource_id',
            SfConstants::SF_WORKITEMDETAIL_RANK_ID           => 'user_member0_rank_id',
            SfConstants::SF_WORKITEMDETAIL_PROJECT_DETAIL_ID => sf_project_details[index]['Id'],
          ).once
        end

        expect(client_mock).to have_received(:create).with(*create_user_member1_work_item_params).once
        3.times do |index|
          expect(client_mock).to have_received(:create).with(
            SfConstants::SF_WORKITEMDETAILS,
            SfConstants::SF_WORKITEMDETAIL_WORKITEM_ID       => 'user_member1_work_item_id',
            SfConstants::SF_WORKITEMDETAIL_START_DATE        => project_contract_on.next_month(index).to_s,
            SfConstants::SF_WORKITEMDETAIL_END_DATE          => project_contract_on.next_month(index).end_of_month.to_s,
            SfConstants::SF_WORKITEMDETAIL_RESOURCE_ID       => 'user_member1_resource_id',
            SfConstants::SF_WORKITEMDETAIL_RANK_ID           => 'user_member1_rank_id',
            SfConstants::SF_WORKITEMDETAIL_PROJECT_DETAIL_ID => sf_project_details[index]['Id'],
          ).once
        end
      end
    end

    context 'sf_project is present' do
      let(:params) do
        {
          project_cd: nebill_project.cd,
          action: 'create_or_update_project',
        }
      end
      let(:update_project_params) do
        [
          SfConstants::SF_PROJECTS,
          SfConstants::SF_PROJECT_ID                     => 'sf_project_id',
          SfConstants::SF_PROJECT_NAME                   => nebill_project.name,
          SfConstants::SF_PROJECT_CD                     => nebill_project.cd,
          SfConstants::SF_PROJECT_START_DATE             => nebill_project.contract_on.to_s,
          SfConstants::SF_PROJECT_END_DATE               => nebill_project.end_on.present? ? nebill_project.end_on.to_s : Time.zone.today.to_s,
          SfConstants::SF_PROJECT_PERIOD_UNIT            => '月',
          SfConstants::SF_PROJECT_MANDAYS_UNIT           => '人時',
          SfConstants::SF_PROJECT_GROSS_MARGIN_RATE_PLAN => 20,
        ]
      end

      before { subject }

      example 'The sf_client calls client.update() with correct params' do
        expect(client_mock).to have_received(:update).with(*update_project_params)
      end
    end
  end

  context 'action == destroy_project' do
    let(:params) do
      {
        project_cd: nebill_project.cd,
        action: 'destroy_project',
      }
    end

    before { subject }

    example 'The sf_client calls client.destroy() with correct params' do
      expect(client_mock).to have_received(:destroy).with(SfConstants::SF_PROJECTS, 'sf_project_id')
    end
  end

  context 'action == create_work_item_and_details' do
    let(:params) do
      {
        project_cd: nebill_project.cd,
        user_members_name: [user_member0.user.name],
        action: 'create_work_item_and_details',
      }
    end
    let(:create_user_member0_work_item_params) do
      [
        SfConstants::SF_WORKITEMS,
        SfConstants::SF_WORKITEM_PROJECT_ID => 'sf_project_id',
        SfConstants::SF_WORKITEM_NAME       => user_member0.user.name,
      ]
    end

    before do
      allow(client_mock).to receive(:create).with(*create_user_member0_work_item_params).and_return('user_member0_work_item_id')
      subject
    end

    example 'The sf_client calls client.create() with correct params' do
      expect(client_mock).to have_received(:create).with(*create_user_member0_work_item_params).once
      3.times do |index|
        expect(client_mock).to have_received(:create).with(
          SfConstants::SF_WORKITEMDETAILS,
          SfConstants::SF_WORKITEMDETAIL_WORKITEM_ID       => 'user_member0_work_item_id',
          SfConstants::SF_WORKITEMDETAIL_START_DATE        => project_contract_on.next_month(index).to_s,
          SfConstants::SF_WORKITEMDETAIL_END_DATE          => project_contract_on.next_month(index).end_of_month.to_s,
          SfConstants::SF_WORKITEMDETAIL_RESOURCE_ID       => 'user_member0_resource_id',
          SfConstants::SF_WORKITEMDETAIL_RANK_ID           => 'user_member0_rank_id',
          SfConstants::SF_WORKITEMDETAIL_PROJECT_DETAIL_ID => sf_project_details[index]['Id'],
        ).once
      end
    end
  end

  context 'action == destroy_work_item_and_details' do
    let(:params) do
      {
        project_cd: nebill_project.cd,
        user_members_name: [user_member0.user.name],
        action: 'destroy_work_item_and_details',
      }
    end
    let(:work_item_info_hash) do
      {
        user_member0.user.name => { work_item_id: 'user_member0_work_item_id' },
      }
    end

    before do
      job.instance_variable_set(:@work_item_info_hash, work_item_info_hash)
      subject
    end

    example 'The sf_client calls client.destroy() with correct params' do
      expect(client_mock).to have_received(:destroy).with(SfConstants::SF_WORKITEMS, 'user_member0_work_item_id').once
    end
  end
end
