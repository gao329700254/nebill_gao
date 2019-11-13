class Approvals::SearchApprovalService < BaseService
  attr_reader :approval

  def initialize(params:, current_user:)
    @created_at =      params[:created_at]
    @search_keywords = params[:search_keywords]
    @status =          params[:status]
    @category =        params[:category]
    @page =            params[:page]
    @current_user =    current_user
  end

  def execute
    approvals = Approval.search_approval(current_user: @current_user, search_created_at: @created_at).only_approval
    if @search_keywords.present?
      search_keywords = @search_keywords.sub(/\A[[:space:]]+/, "").split(/[[:blank:]]+/)
      search_keywords.each do |keyword|
        relation = approvals.joins(created_user: :employee)
        approvals = relation.where(['approvals.name LIKE ?', "%#{keyword}%"]).or(relation.where(['employees.name LIKE ?', "%#{keyword}%"]))
      end
    end
    approvals = approvals.where(status: @status) if @status.present?
    approvals = approvals.where(category: @category) if @category.present?
    @approvals = approvals.order(created_at: :desc).page(@page).per(20)
  end
end
