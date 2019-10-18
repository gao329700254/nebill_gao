class Projects::CsvController < ApplicationController
  before_action :set_projects

  def download
    respond_to do |format|
      format.csv { send_data render_to_string, type: :csv }
    end
  end

private

  def set_projects
    @projects = Project.all
    select_by_contracted
    select_by_start_on_and_end_on
    select_by_status
    select_by_unprocessed
    sort
  end

  def select_by_contracted
    @projects =
      case params[:contract_status]
      when 'contracted'
        @projects.where(contracted: true)
      when 'uncontracted'
        @projects.where(contracted: false)
      else
        @projects
      end
  end

  def select_by_start_on_and_end_on
    @projects = @projects.gteq_start_on(params[:start]) if params[:start].present?
    @projects = @projects.lteq_end_on(params[:end]) if params[:end].present?
  end

  def select_by_status
    @projects =
      case params[:status]
      when 'progress'
        @projects.where.not(status: :finished)
      when 'finished'
        @projects.where(status: :finished)
      else
        @projects
      end
  end

  def select_by_unprocessed
    @projects = @projects.where(unprocessed: true) if params[:status] == 'unprocessed'
  end

  def sort
    return if @projects.blank?
    @projects = @projects.group_by { |p| p.cd[2] }.sort.to_h.values
    @projects = @projects.map { |projects| projects.sort_by(&:cd).reverse }.flatten
  end
end
