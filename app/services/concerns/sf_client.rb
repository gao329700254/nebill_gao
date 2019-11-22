class SfClient
  include SfConstants, GetSfObjs

  def create_project(nebill_project)
    client.create(SF_PROJECTS, create_project_params(nebill_project))
  end

  def update_project(sf_project_id, nebill_project)
    client.update(SF_PROJECTS, update_project_params(sf_project_id, nebill_project))
  end

  def destroy_project(sf_project_id)
    client.destroy(SF_PROJECTS, sf_project_id)
  end

  def create_work_item_and_details(sf_project_info, work_item_info_hash)
    work_item_info_hash.each do |resource_name, work_item_info|
      work_item_info[:work_item_id] = client.create(SF_WORKITEMS, work_item_params(sf_project_info[:sf_project_id], resource_name))

      month_diff = ((sf_project_info[:sf_project_end_date] - sf_project_info[:sf_project_start_date]).to_f / 365 * 12).round
      (month_diff + 1).times do |index|
        client.create(SF_WORKITEMDETAILS, work_item_detail_params(sf_project_info, work_item_info, index))
      end
    end
  end

  def destroy_work_item_and_details(work_item_id)
    client.destroy(SF_WORKITEMS, work_item_id) if work_item_id.present?
  end

private

  def client
    @client ||= Restforce.new
  end

  def create_project_params(nebill_project)
    {
      SF_PROJECT_NAME                   => nebill_project.name,
      SF_PROJECT_CD                     => nebill_project.cd,
      SF_PROJECT_START_DATE             => nebill_project.contract_on.to_s,
      SF_PROJECT_END_DATE               => nebill_project.end_on.present? ? nebill_project.end_on.to_s : Time.zone.today.next_year.to_s,
      SF_PROJECT_PERIOD_UNIT            => '月',
      SF_PROJECT_MANDAYS_UNIT           => '人時',
      SF_PROJECT_GROSS_MARGIN_RATE_PLAN => 20,
    }
  end

  def update_project_params(sf_project_id, nebill_project)
    base_params = create_project_params(nebill_project)
    base_params[SF_PROJECT_ID] = sf_project_id if sf_project_id.present?
    base_params
  end

  def work_item_params(sf_project_id, resource_name)
    {
      SF_WORKITEM_PROJECT_ID => sf_project_id,
      SF_WORKITEM_NAME       => resource_name,
    }
  end

  def work_item_detail_params(sf_project_info, work_item_info, index)
    {
      SF_WORKITEMDETAIL_WORKITEM_ID       => work_item_info[:work_item_id],
      SF_WORKITEMDETAIL_RESOURCE_ID       => work_item_info[:resource_id],
      SF_WORKITEMDETAIL_RANK_ID           => work_item_info[:rank_id],
      SF_WORKITEMDETAIL_START_DATE        => sf_project_info[:sf_project_start_date].next_month(index).to_s,
      SF_WORKITEMDETAIL_END_DATE          => sf_project_info[:sf_project_start_date].next_month(index).end_of_month.to_s,
      SF_WORKITEMDETAIL_PROJECT_DETAIL_ID => sf_project_info[:sf_project_details].find do |d|
        project_detail_start_date = Date.parse(d[SF_PROJECTDETAIL_START_DATE.to_s])
        next_month = sf_project_info[:sf_project_start_date].next_month(index)
        project_detail_start_date.month == next_month.month && project_detail_start_date.year == next_month.year
      end['Id'],
    }
  end
end
