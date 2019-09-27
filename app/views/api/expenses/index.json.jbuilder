json.expense_approval do
  json.approval_list            @expense_approval
  json.status                   @eappr&.status_i18n || I18n.t("page.expense_list.unapplove")
end
