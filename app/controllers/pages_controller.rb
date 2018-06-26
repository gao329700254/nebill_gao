class PagesController < ApplicationController
  skip_authorize_resource     only: [:home]
  before_action :set_project     , only: [:project_show]
  before_action :set_bill        , only: [:bill_show]
  before_action :set_client      , only: [:client_show]
  before_action :set_approval    , only: [:approval_show, :approval_edit]
  before_action :create_approval , only: [:approval_new]

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

  def approval_list
  end

  def approval_show
    unless @approval.created_user_id == @current_user.id || @current_user_approval.present? || can?(:allread, Approval)
      redirect_to approval_list_path
      return
    end
  end

  def approval_new
  end

  def approval_edit
    redirect_to approval_list_path unless @approval.status == 30 && (@approval.created_user_id == @current_user.id || can?(:allread, Approval))
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

  def set_approval
    @approval = Approval.find(params[:approval_id])
    @approval_users = @approval.approval_users.includes(:user)
    @unable_user = @approval_users.pluck :user_id
    @unable_user << @approval.created_user_id
    @users = User.where.not(id: @unable_user)
    @new_user = User.new
    @current_user_approval = @approval_users.find_by(user_id: @current_user.id)
    @approval_files = @approval.files
  end

  def create_approval
    @approval = Approval.new
  end
end
