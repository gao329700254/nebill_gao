# Preview all emails at http://localhost:3000/rails/mailers/approval_mailer
class ApprovalMailerPreview < ActionMailer::Preview
  def approval_mailer
    @approval_user = ApprovalUser.first
    @approval = Approval.first
    ApprovalMailer.assignment_user(user: @approval_user.user, approval: @approval).deliver_now
  end

  def update_approval
    @approval_user = ApprovalUser.first
    @approval = Approval.first
    ApprovalMailer.update_approval(user: @approval_user.user, approval: @approval).deliver_now
  end

  def permission_approval
    @approval = Approval.first
    @user = @approval.created_user
    ApprovalMailer.permission_approval(user: @user, approval: @approval).deliver_now
  end

  def disconfirm_approval
    @approval = Approval.first
    @user = @approval.created_user
    ApprovalMailer.disconfirm_approval(user: @user, approval: @approval).deliver_now
  end
end
