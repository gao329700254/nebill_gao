class ProjectMailer < ApplicationMailer
  def assignment_user(user:, approval:)
    @user             = user
    @approval         = approval
    mail to:      user.email,
         subject: I18n.t("mail.project.assignment.subject", user: @approval.created_user.name, name: @approval.name)
  end

  def update_project_approval(user:, approval:)
    @user             = user
    @approval         = approval
    mail to:      user.email,
         subject: I18n.t("mail.project.update.subject", user: @user.name, name: @approval.name)
  end

  def permission_project_approval(user:, approval:)
    @user             = user
    @approval         = approval
    mail to:      user.email,
         subject: I18n.t("mail.project.permission.subject", user: @user.name, name: @approval.name)
  end

  def disconfirm_project_approval(user:, approval:)
    @user             = user
    @approval         = approval
    mail to:      user.email,
         subject: I18n.t("mail.project.disconfirm.subject", user: @user.name, name: @approval.name)
  end
end
