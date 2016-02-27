class PagesController < ApplicationController
  before_action :set_project, only: [:project_show]

  def home
  end

  def project_new
  end

  def project_list
  end

  def project_show
  end

  def project_groups
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
