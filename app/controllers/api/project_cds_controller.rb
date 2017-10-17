class Api::ProjectCdsController < Api::ApiController
  PROJECT_TYPES = %w(lump_sum uncontracted consignment maintenance ses other).freeze

  before_action :set_project_type, only: [:cd]

  def cd
    @prefix = Time.zone.today.strftime("%y") + identifier(@project_type)
    @cd = { cd: @prefix + format("%03d", Project.sequence(@prefix)) + (@project_type == 'uncontracted' ? 'B' : 'A') }

    render json: @cd, status: :ok
  end

private

  def identifier(project_type)
    case project_type
    when 'lump_sum', 'uncontracted'
      return 'D'
    when 'consignment'
      return 'K'
    when 'maintenance'
      return 'M'
    when 'ses'
      return 'S'
    when 'other'
      return 'W'
    end
  end

  def set_project_type
    if PROJECT_TYPES.include?(params[:project_type])
      @project_type = params[:project_type]
    else
      render_not_found_message
    end
  end
end
