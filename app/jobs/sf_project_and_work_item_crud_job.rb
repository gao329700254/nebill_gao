class SfProjectAndWorkItemCrudJob < ActiveJob::Base
  queue_as :default
  attr_accessor :project_cd, :user_names

  def perform(params)
    return if Rails.application.secrets.sf_username.blank?

    @project_cd = params[:project_cd]
    @user_names = params[:user_names]

    exec_action(params[:action])
  end

private

  def exec_action(action)
    case action
    when 'create_project'
      sf_client.create_project(nebill_project)
      sf_client.create_work_item_and_details(sf_project_info, work_item_info_hash)
    when 'update_project'
      sf_client.update_project(sf_project_info[:sf_project_id], nebill_project)
    when 'destroy_project'
      sf_client.destroy_project(sf_project_info[:sf_project_id])
    when 'create_work_item_and_details'
      sf_client.create_work_item_and_details(sf_project_info, work_item_info_hash)
    when 'destroy_work_item_and_details'
      sf_client.destroy_work_item_and_details(work_item_info_hash[@user_names.first][:work_item_id])
    end
  end

  def sf_client
    @sf_client ||= SfClient.new
  end

  def nebill_project
    @nebill_project ||= Project.find_by_cd(project_cd)
  end

  def sf_project_info
    @sf_project_info ||= sf_client.get_sf_project(project_cd)
  end

  def work_item_info_hash
    @work_item_info_hash ||= sf_client.get_work_item(
      sf_project_info[:sf_project_id],
      sf_client.get_sf_resource_and_rank(user_names),
    )
  end
end
