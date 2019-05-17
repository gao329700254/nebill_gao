class ClientMailer < ApplicationMailer
  def assignment_user(user:, approval:)
    @user             = user
    @approval         = approval
    mail to:      user.email,
         subject: I18n.t("mail.client.assignment.subject", user: @approval.created_user.name, name: @approval.name)
  end

  def update_client_approval(user:, approval:)
    @user             = user
    @approval         = approval
    mail to:      user.email,
         subject: I18n.t("mail.client.update.subject", user: @user.name, name: @approval.name)
  end

  def nda_permission_client_approval(user:, approval:)
    @user             = user
    @approval         = approval
    mail to:      user.email,
         subject: I18n.t("mail.client.nda_permission.subject", user: @user.name, name: @approval.name)
  end

  def permission_client_approval(user:, approval:)
    @user             = user
    @approval         = approval
    mail to:      user.email,
         subject: I18n.t("mail.client.permission.subject", user: @user.name, name: @approval.name)
  end

  def disconfirm_client_approval(user:, approval:)
    @user             = user
    @approval         = approval
    mail to:      user.email,
         subject: I18n.t("mail.client.disconfirm.subject", user: @user.name, name: @approval.name)
  end
end
