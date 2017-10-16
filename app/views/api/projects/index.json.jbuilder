json.array!(@projects) do |project|
  json.extract!(
    project,
    :id,
    :group_id,
    :contracted,
    :contract_type,
    :is_using_ses,
    :payment_type,
    :estimated_amount,
    :billing_company_name,
    :billing_department_name,
    :billing_address,
    :billing_zip_code,
    :billing_phone_number,
    :billing_memo,
    :orderer_department_name,
    :orderer_address,
    :orderer_zip_code,
    :orderer_phone_number,
    :orderer_memo,
    :billing_personnel_names,
    :orderer_personnel_names,
    :created_at,
    :updated_at,
  )
  json.is_regular_contract           project.is_regular_contract ? I18n.t("enumerize.defaults.regular_contract") : ''
  json.cd                            project.cd
  json.status                        project.status ? I18n.t("enumerize.defaults.status.#{project.status}") : ''
  json.name                          project.name
  json.orderer_company_name          project.orderer_company_name
  json.start_on                      project.start_on
  json.end_on                        project.end_on
  json.contract_on                   project.contract_on
  json.amount                        project.amount
end
