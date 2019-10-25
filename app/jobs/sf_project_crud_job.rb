class SfProjectCrudJob < ActiveJob::Base
  queue_as :default
  include SfConstants

  def perform(params)
    return if Rails.application.secrets.sf_username.blank?
    set_nebill_and_sf_project(params)

    if params[:action] == 'create_or_update'
      @sf_project_id.present? ? sf_client.update(SF_PROJECTS, sf_params) : sf_client.create(SF_PROJECTS, sf_params)
    elsif params[:action] == 'destroy'
      sf_client.destroy(SF_PROJECTS, @sf_project_id)  if @sf_project_id.present?
    end
  end

private

  def sf_client
    @sf_client ||= Restforce.new
  end

  def sf_params
    base_params = {
      SF_NAME                   => @nebill_project.name,
      SF_CD                     => @nebill_project.cd,
      SF_CONTRACT_ON            => @nebill_project.contract_on.to_s,
      SF_END_ON                 => @nebill_project.end_on.present? ? @nebill_project.end_on.to_s : Time.zone.today.next_year.to_s,
      SF_PERIOD_UNIT            => '月',
      SF_MANDAYS_UNIT           => '人時',
      SF_GROSS_MARGIN_RATE_PLAN => 20,
    }
    base_params[SF_ID] = @sf_project_id if @sf_project_id.present?
    base_params
  end

  # rubocop:disable Style/AccessorMethodName
  def set_nebill_and_sf_project(params)
    @nebill_project = Project.find_by_cd(params[:project_cd])
    sf_project = sf_client.query("select ID from #{SF_PROJECTS} where #{SF_CD} = '#{params[:project_cd]}'")
    @sf_project_id = sf_project.size > 0 ? sf_project.first['Id'] : nil
  end
  # rubocop:enable Style/AccessorMethodName
end
