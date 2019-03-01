class Approvals::UpdateApprovalService < BaseService
  attr_reader :approval

  def initialize(approval_params:, update_params:)
    @approval_params = approval_params
    @update_params = update_params
  end

  def execute
    @approval ||= find_approval
    @approval.attributes = approval_params
    if @approval.valid?
      @approval.save!
      return true
    end
    false
  rescue
    false
  end

private

  attr_reader :approval_params, :update_params

  def find_approval
    Approval.find(update_params[:id])
  end
end
