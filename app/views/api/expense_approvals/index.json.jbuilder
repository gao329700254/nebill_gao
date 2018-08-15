json.array!(@expense_approvals) do |expense_approval|
  json.extract! expense_approval, :id, :name, :status_text, :created_user_id, :notes
  json.name                          expense_approval.name
  json.status                        expense_approval.status_text
  json.created_user_name             expense_approval.created_user.name
  json.created_at                    expense_approval.created_at.strftime("%Y-%m-%d %H:%M")
end
