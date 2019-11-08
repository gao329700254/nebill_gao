class Approvals::SearchApprovalService < BaseService
  attr_reader :approval

  def initialize(params:, current_user:)
    @created_at = params[:created_at]
    @search_keywords = params[:search_keywords]
    @status = params[:status]
    @category = params[:category]
    @page =  params[:page]
    @current_user = current_user
  end

  def call
    @approvals = Approval.search_approval(current_user: @current_user, search_created_at: @created_at).includes(:created_user).only_approval.to_a
    search_by_keywords
    search_by_status
    search_by_category
    @approvals = Approval.where(id: @approvals.map(&:id)).order(created_at: :desc).page(@page).per(20)
  end

private

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def search_by_keywords
    if @search_keywords && @search_keywords != ''
      search_keywords = @search_keywords.sub(/\A[[:space:]]+/, "").split(/[[:blank:]]+/)
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
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity

  def search_by_status
    @approvals.select! { |app| app.status == @status } if @status.present?
  end

  def search_by_category
    @approvals.select! { |app| app.category == @category } if @category.present?
  end
end
