json.array! @bills do |bill|
  json.id                   bill.id
  json.cd                   bill.cd
  json.name                 bill.project.name
  json.orderer_company_name bill.project.orderer_company_name
  json.amount               bill.amount
  json.payment_type         I18n.t("enumerize.defaults.payment_type.#{bill.payment_type}") if bill.payment_type.present?
  json.created_by           bill.applicant.user.name
  json.created_at           I18n.l(bill.created_at.in_time_zone('Tokyo'))
end
