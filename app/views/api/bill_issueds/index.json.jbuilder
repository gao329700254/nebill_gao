json.array! @bills do |bill|
  json.extract! bill, :id, :project_id, :delivery_on, :acceptance_on, :bill_on, :created_at, :updated_at, :memo
  json.cd                                       bill.cd
  json.project do
    json.name                                   bill.project.name
    json.billing_company_name                   bill.project.billing_company_name
  end
  json.amount                                   bill.amount
  json.payment_type                             I18n.t("enumerize.defaults.payment_type.#{bill.payment_type}") if bill.payment_type.present?
  json.expected_deposit_on                      bill.expected_deposit_on
  json.status                                   bill.status_i18n
  json.deposit_on                               bill.deposit_on
  json.deposit_confirmed_memo                   bill.deposit_confirmed_memo
end
