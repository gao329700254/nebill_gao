class ExpenseApprovalMailer < ApplicationMailer
  def assignment_user(user:, expense_approval:)
    @user             = user
    @expense_approval = expense_approval
    mail to:      user.email,
         subject: I18n.t("mail.expense_approval.assignment.subject", user: @expense_approval.created_user.name, name: @expense_approval.name)
  end

  def update_expense_approval(user:, expense_approval:)
    @user             = user
    @expense_approval = expense_approval
    mail to:      user.email,
         subject: I18n.t("mail.expense_approval.update.subject", user: @user.name, name: @expense_approval.name)
  end

  def permission_expense_approval(user:, expense_approval:)
    @user             = user
    @expense_approval = expense_approval
    mail to:      user.email,
         subject: I18n.t("mail.expense_approval.permission.subject", user: @user.name, name: @expense_approval.name)
  end

  def disconfirm_expense_approval(user:, expense_approval:)
    @user             = user
    @expense_approval = expense_approval
    mail to:      user.email,
         subject: I18n.t("mail.expense_approval.disconfirm.subject", user: @user.name, name: @expense_approval.name)
  end
end
