json.array!(@project) do |project|
  json.id                        project.id
  json.name                      project.name
  json.orderer_company_name      project.orderer_company_name
  json.start_on                  project.start_on
  json.end_on                    project.end_on
  json.contract_on               project.contract_on
  json.amount                    project.amount
  json.is_regular_contract       project.is_regular_contract ? I18n.t("enumerize.defaults.regular_contract") : ''
  json.status                    project.status_text
  json.created_at                I18n.l(project.created_at.in_time_zone('Tokyo'))
  json.whodunnit                 project.approvals.last.created_user.name
end
