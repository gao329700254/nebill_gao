module GetSfObjs
  include SfConstants

  def get_sf_project(project_cd)
    sf_project_result = client.query(
      <<~"SOQL"
        select #{['Id', SF_PROJECT_START_DATE, SF_PROJECT_END_DATE].join(', ')}
        from #{SF_PROJECTS}
        where #{SF_PROJECT_CD} = '#{project_cd}'
      SOQL
    )
    return if sf_project_result.size == 0
    sf_project_id         = sf_project_result.first['Id']
    sf_project_start_date = Date.parse(sf_project_result.first[SF_PROJECT_START_DATE.to_s]).beginning_of_month
    sf_project_end_date   = Date.parse(sf_project_result.first[SF_PROJECT_END_DATE.to_s]).beginning_of_month

    sf_project_details = client.query(
      <<~"SOQL"
        select #{['Id', SF_PROJECTDETAIL_START_DATE].join(', ')}
        from #{SF_PROJECTDETAILS}
        where #{SF_PROJECTDETAIL_PROJECT_ID} = '#{sf_project_id}'
      SOQL
    ).to_a
    {
      sf_project_id:         sf_project_id,
      sf_project_start_date: sf_project_start_date,
      sf_project_end_date:   sf_project_end_date,
      sf_project_details:    sf_project_details,
    }
  end

  def get_sf_resource_and_rank(user_names)
    return if user_names.blank?
    work_item_info = {}
    user_names.each do |nebill_user_name|
      # SFでリソースの名前の値は人の名前で、現時点では同姓同名の人がいなくて、人の名前が一意のため、リソースの主キーは人の名前にしています。
      sf_resource_result = client.query(
        <<~"SOQL"
          select #{['Id', SF_WORKITEMDETAIL_RANK_ID].join(', ')}
          from #{SF_RESOURCES}
          where #{SF_RESOURCE_NAME} = '#{nebill_user_name}'
        SOQL
      )
      next if sf_resource_result.size == 0
      work_item_info[nebill_user_name] = {
        resource_id:   sf_resource_result.first['Id'],
        rank_id:       sf_resource_result.first[SF_WORKITEMDETAIL_RANK_ID.to_s],
      }
    end
    work_item_info
  end

  def get_work_item(sf_project_id, work_item_info)
    return if work_item_info.blank?
    work_item_info.each do |nebill_user_name, wi_info|
      work_item_ids = client.query(
        <<~"SOQL"
          select name, #{SF_WORKITEMDETAIL_WORKITEM_ID}
          from #{SF_WORKITEMDETAILS}
          where #{SF_WORKITEMDETAIL_RESOURCE_ID} = '#{wi_info[:resource_id]}' and
            #{SF_WORKITEMDETAIL_WORKITEM_ID} in
              (
                select Id
                from #{SF_WORKITEMS}
                where #{SF_WORKITEM_PROJECT_ID} = '#{sf_project_id}'
              )
        SOQL
      )
      next if work_item_ids.size == 0
      work_item_info[nebill_user_name][:work_item_id] = work_item_ids.first[SF_WORKITEMDETAIL_WORKITEM_ID.to_s]
    end
    work_item_info
  end
end
