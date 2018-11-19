class Approvals::CreateApprovalService < BaseService
  attr_reader :approval

  def initialize(approval_params:, create_params:)
    @approval_params = approval_params
    @create_params = create_params
  end

  def execute
    @approval ||= create_approval
    @build_user ||= build_approval_user
    if @approval.valid? && @build_user.valid?
      Approval.transaction do
        @approval.save!
        @build_user.save!
      end
      create_notice
      return true
    end
    false
  rescue
    false
  end

private

  attr_reader :approval_params, :create_params

  def create_approval
    Approval.new(approval_params)
  end

  def build_approval_user
    approval.approval_users.build(user_id: create_params[:user_id])
  end

  def create_notice
    ApprovalMailer.assignment_user(user: @build_user.user, approval: @approval).deliver_now
    Chatwork::Approval.new(approval: @approval, to_user: @build_user.user).notify_assigned
  end
end
