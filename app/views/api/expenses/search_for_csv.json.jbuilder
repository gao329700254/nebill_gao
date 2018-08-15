json.array!(@expenses) do |expense|
  json.extract! expense, :id
  json.use_date                 expense.use_date
  json.default_id               expense.default.name
  json.amount                   expense.amount
  json.notes                    expense.notes
  json.status                   expense.expense_approval.status_text
  json.expense_approval_id      expense.expense_approval_id
  json.approval_created_at      expense.expense_approval.created_at.strftime("%Y-%m-%d %H:%M")
  json.created_user_name        expense.expense_approval.created_user.name
  json.default_allower          expense.expense_approval.expense_approval_user.last.user.name
  json.depatture_location       expense.depatture_location
  json.arrival_location         expense.arrival_location
  json.payment_type             expense.payment_type_text
  if expense.default.is_receipt
    json.receipt                '有り'
  else
    json.receipt                '無し'
  end
end
