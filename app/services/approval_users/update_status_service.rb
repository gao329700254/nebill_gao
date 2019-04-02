class ApprovalUsers::UpdateStatusService < BaseService
  attr_reader :approval

  def initialize(update_params:, current_user:)
    @update_params = update_params
    @current_user = current_user
  end

  def execute
    @approval ||= find_approval
    @set_user ||= find_current_approval_user
    if @set_user.valid? && @approval.valid?
      Approval.transaction do
        @set_user.update!(status: update_params[:button], comment: update_params[:comment])
      end
      return true
    end
    false
  rescue
    false
  end

private

  attr_reader :update_params, :current_user

  def find_approval
    Approval.find(update_params[:approval_id])
  end

  def find_current_approval_user
    @approval.approval_users.includes(:user).find_by(user_id: current_user.id)
  end
end
