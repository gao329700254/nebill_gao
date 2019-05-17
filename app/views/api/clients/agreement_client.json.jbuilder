json.array!(@client.includes(:files)) do |client|
  json.id              client.id
  json.company_name    client.company_name
  json.department_name client.department_name
  json.created_at      I18n.l(client.created_at.in_time_zone('Tokyo'))
  json.whodunnit       client.approvals.last.created_user.name
  json.nda             client.files[0]
  json.basic_c         client.files[1]
end
