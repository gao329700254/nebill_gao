json.array!(@approvals) do |approval|
  json.extract! approval, :id, :name, :project_id, :status_text, :created_user_id, :notes
  json.name                          approval.name.truncate(40)
  json.approvaler_type               approval.approvaler_type_text
  json.category                      approval.category_text
  json.status                        approval.status_text
  json.created_user_name             approval.created_user.name
  json.created_at                    approval.created_at.strftime("%Y-%m-%d %H:%M")
end
