class ApprovalUsers::AddApprovalUserService < BaseService
  def initialize(create_params:, current_user:)
    @create_params = create_params
    @current_user = current_user
  end

  def execute
    @approval ||= find_approval
    @build_user ||= build_approval_user
    @set_user ||= find_current_approval_user
    if create_valid?
      Approval.transaction do
        @approval.status != 20 || @approval.update!(status: 10)
        @build_user.save!
        @set_user.nil? || @set_user&.update!(status: 40)
      end
      create_notice
      return true
    end
    false
  rescue
    false
  end

private

  attr_reader :create_params, :current_user

  def find_approval
    Approval.find(create_params[:approval_id])
  end

  def build_approval_user
    @approval.approval_users.build(user_id: create_params[:user][:id]) if create_params[:user][:id]
  end

  def find_current_approval_user
    @approval.approval_users.includes(:user).find_by(user_id: current_user.id)
  end

  def create_notice
    ApprovalMailer.assignment_user(user: @build_user.user, approval: @approval).deliver_now
    Chatwork::Approval.new(approval: @approval, to_user: @build_user.user).notify_assigned
  end

  def create_valid?
    @approval.valid? && @build_user.valid? && (@set_user.nil? || @set_user&.valid?)
  end
end
