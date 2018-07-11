class PagesController < ApplicationController
  skip_authorize_resource     only: [:home]

  before_action :set_project, only: [:project_show]
  before_action :set_bill   , only: [:bill_show]
  before_action :set_client , only: [:client_show]

  def home
    unless current_user.blank?
      redirect_to project_list_path
      return
    end
    render layout: 'simple'
  end

  def client_list
  end

  def client_show
  end

  def project_new
  end

  def project_list
  end

  def project_show
  end

  def bill_show
  end

  def project_groups
  end

  def bill_list
  end

  def partners
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_bill
    @bill = Bill.find(params[:bill_id])
  end

  def set_client
    @client = Client.find(params[:client_id])
  end
end
