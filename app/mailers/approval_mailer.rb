class ApprovalMailer < ApplicationMailer
  def assignment_user(user:, approval:)
    @user     = user
    @approval = approval
    mail to:      user.email,
         subject: I18n.t("mail.approval.assignment.subject", user: @approval.created_user.name, name: @approval.name)
  end

  def update_approval(user:, approval:)
    @user     = user
    @approval = approval
    mail to:      user.email,
         subject: I18n.t("mail.approval.update.subject", user: @user.name, name: @approval.name)
  end

  def permission_approval(user:, approval:)
    @user     = user
    @approval = approval
    mail to:      user.email,
         subject: I18n.t("mail.approval.permission.subject", user: @user.name, name: @approval.name)
  end

  def disconfirm_approval(user:, approval:)
    @user     = user
    @approval = approval
    mail to:      user.email,
         subject: I18n.t("mail.approval.disconfirm.subject", user: @user.name, name: @approval.name)
  end
end
