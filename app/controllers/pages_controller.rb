# rubocop:disable Metrics/ClassLength
class PagesController < ApplicationController
  skip_authorize_resource     only: [:home]
  before_action :set_project              , only: [:project_show]
  before_action :set_client               , only: [:client_show]
  before_action :create_approval          , only: [:approval_new]
  before_action :set_expense              , only: [:expense_edit]
  before_action :create_expense           , only: [:expense_new]
  before_action :create_expense_approval  , only: [:expense_approval_new]
  before_action :set_expense_approval     , only: [:expense_approval_show, :expense_approval_edit]
  before_action :set_expense_list         , only: [:expense_list]
  before_action :set_agreement_list       , only: [:agreement_list]

  def home
    unless current_user.blank?
      redirect_to current_user.role.outer? ? approval_list_path : project_list_path
      return
    end
    @user_session = UserSession.new
    render layout: 'simple'
  end

  def client_list
  end

  def client_show
  end

  def project_new
  end

  def project_new_form
  end

  def project_list
  end

  def project_show
  end

  def bill_show
    @bill = Bill.find(params[:bill_id])
    @bill_applicant   = @bill.applicant
    @bill_approvers   = @bill.approvers.order(role: :asc)
    @current_approver = @bill.approvers.find_by(user_id: @current_user.id)
  end

  def project_groups
  end

  def bill_list
  end

  def partners
  end

  def approval_list
    @approvals = search_approval.only_approval.to_a
    sort_by_keywords
    sort_by_status
    sort_by_category
    @approvals = Approval.where(id: @approvals.map(&:id)).order(created_at: :desc).page(params[:page]).per(20)
  end

  def approval_show
    @approval = Approval.find(params[:approval_id])
    @approval_individual_group_switch = ApprovalIndividualGroupSwitch.new(@approval, current_user)
    unless @approval.created_user_id == @current_user.id || @approval_individual_group_switch.current_user_approval.present? || can?(:allread, Approval)
      redirect_to approval_list_path
      return
    end
  end

  def approval_new
  end

  def approval_edit
    @approval = Approval.find(params[:approval_id])
    @approval_individual_group_switch = ApprovalIndividualGroupSwitch.new(@approval, current_user)

    redirect_to approval_list_path unless @approval.status == 30 && (@approval.created_user_id == @current_user.id || can?(:allread, Approval))
    @approval.status = 10
  end

  def expense_new
  end

  def expense_list
  end

  def expense_edit
  end

  def expense_approval_new
  end

  def expense_approval_list
  end

  def expense_approval_edit
    redirect_to expense_approval_list_path unless @expense_approval.status == 30 \
    && (@expense_approval.created_user_id == @current_user.id || can?(:allread, ExpenseApproval))
  end

  def expense_approval_show
  end

  def agreement_list
  end

private

  def set_project
    @project = Project.find(params[:project_id])
    @approval = Approval.find_by(approved_type: 'Project', approved_id: @project.id)
    @current_user_approval = ApprovalUser.find_by(approval_id: @approval.id, user_id: @current_user.id) if @approval.present?
  end

  def set_client
    @client = Client.find(params[:client_id])
    @approval = Approval.find_by(approved_type: 'Client', approved_id: @client.id)
    @current_user_approval = ApprovalUser.find_by(approval_id: @approval.id, user_id: @current_user.id) if @approval.present?
  end

  def create_approval
    @approval = Approval.new
    @approval.build_approval_approval_group
    @approval.approval_users.build
    @approval.created_user_id = @current_user.id
  end

  def set_expense
    @expense = Expense.find(params[:expense_id])
    @default = @expense.default
    @default_expense_items = DefaultExpenseItem.all
    @file = @expense.file.new if @expense.file.blank?
    gon.expense_id = params[:expense_id]
    gon.amount = @expense.amount
    gon.is_round_trip = @expense.is_round_trip
    gon.project = @expense.project_id
  end

  def create_expense
    @expense = Expense.new
    @expense.use_date = Time.zone.today
    @default_expense_items = DefaultExpenseItem.all
    @file = @expense.file.new
    if params[:expense_id]
      @exp = Expense.find(params[:expense_id])
      @expense.use_date = @exp.use_date
      @expense.amount = @exp.amount
      @expense.depatture_location = @exp.depatture_location
      @expense.arrival_location = @exp.arrival_location
      @expense.default_id = @exp.default_id
    end
  end

  def create_expense_approval
    @expense_approval = ExpenseApproval.new
  end

  def set_expense_approval
    @expense_approval = ExpenseApproval.find(params[:expense_approval_id])
    @expense_approval_users = @expense_approval.expense_approval_user.includes(:user)
    @unable_user = @expense_approval_users.pluck :user_id
    @unable_user << @expense_approval.created_user_id
    @users = User.where.not(id: @unable_user)
    @new_user = User.new
    @current_user_approval = @expense_approval_users.find_by(user_id: @current_user.id)
  end

  def set_expense_list
    gon.selectedApproval = params[:selectedApproval] || 0
  end

  def set_agreement_list
    @current_view = params[:format] || 'agreementApprovalList'
  end

  def search_approval
    if params[:created_at].present? && can?(:allread, Approval)
      Approval.where_created_on(params[:created_at]).includes(:created_user)
    elsif params[:created_at].present?
      Approval.related_approval_where_created_on(current_user.id, params[:created_at])
              .includes(:users, created_user: :employee, approval_group: :users)
              .references(approval_group: :users)
    elsif can?(:allread, Approval)
      Approval.includes([:created_user, [users: :employee], :approval_users])
    else
      Approval.related_approval(current_user.id)
              .includes(:users, created_user: :employee, approval_group: :users)
              .references(approval_group: :users)
    end
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def sort_by_keywords
    if params[:search_keywords] && params[:search_keywords] != ''
      search_keywords = params[:search_keywords].sub(/\A[[:space:]]+/, "").split(/[[:blank:]]+/)
      if search_keywords.count == 1
        word = search_keywords[0]
        @approvals.select! { |approval| approval.name.include?(word) || approval.created_user.name.include?(word) }
      elsif search_keywords.count > 1
        search_keywords.each do |keyword|
          @approvals.select! { |approval| approval.name.include?(keyword) || approval.created_user.name.include?(keyword) }
        end
      end
    end
  end

  def sort_by_status
    if params[:status] == t('page.approval_list.status_type.pending')
      @approvals.select! { |app| app.status == "pending" }
    elsif params[:status] == t('page.approval_list.status_type.permission')
      @approvals.select! { |app| app.status == "permission" }
    elsif params[:status] == t('page.approval_list.status_type.disconfirm')
      @approvals.select! { |app| app.status == "disconfirm" }
    elsif params[:status] == t('page.approval_list.status_type.invalid')
      @approvals.select! { |app| app.status == "invalid" }
    end
  end

  # rubocop:disable Metrics/AbcSize
  def sort_by_category
    if params[:category] ==  t('page.approval_list.category_type.contract_relationship')
      @approvals.select! { |app| app.category == "contract_relationship" }
    elsif params[:category] == t('page.approval_list.category_type.new_client')
      @approvals.select! { |app| app.category == "new_client" }
    elsif params[:category] == t('page.approval_list.category_type.consumables')
      @approvals.select! { |app| app.category == "consumables" }
    elsif params[:category] == t('page.approval_list.category_type.other_purchasing')
      @approvals.select! { |app| app.category == "other_purchasing" }
    elsif params[:category] == t('page.approval_list.category_type.other')
      @approvals.select! { |app| app.category == "other" }
    end
  end
end
# rubocop:enable Metrics/ClassLength
