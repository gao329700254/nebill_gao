json.array!(@expense_approvals.includes(:expense)) do |expense_approval|
  json.extract! expense_approval, :id, :name, :status_i18n, :created_user_id, :notes
  json.name                          expense_approval.name
  json.status                        expense_approval.status_i18n
  json.created_user_name             expense_approval.created_user.name
  json.created_at                    expense_approval.created_at.strftime("%Y-%m-%d %H:%M")
  json.reimbursement_start_date      expense_approval.expense.min_by(&:use_date)&.use_date
  json.reimbursement_last_date       expense_approval.expense.max_by(&:use_date)&.use_date
  json.reimbursement_count           expense_approval.expenses_number
  json.reimbursement_amount          expense_approval.total_amount
end
