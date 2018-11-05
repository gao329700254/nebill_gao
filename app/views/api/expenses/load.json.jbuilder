json.list do
  @reimbursement_amount = 0
  @person_rebuilding = 0

  json.array!(@expenses) do |expense|
    json.extract! expense, :id
    json.use_date                 expense.use_date
    json.default_id               expense.default.name
    if expense.default.is_routing
      json.content                expense.depatture_location + (expense.is_round_trip ? ' ↔︎ ' : ' → ') + expense.arrival_location
    end
    json.file                     expense.file.first
    json.is_receipt               expense.default.is_receipt
    json.amount                   expense.amount
    json.notes                    expense.notes
    @reimbursement_amount += expense.amount
    expense.payment_type == 10 && @person_rebuilding += expense.amount
    json.update_flug              can? :update, expense
  end
end

json.total do
  json.reimbursement_amount     @reimbursement_amount
  json.person_rebuilding        @person_rebuilding
end

json.expense_approval do
  json.id                       @eappr&.id || '0'
  json.status                   @eappr&.status_text || I18n.t("page.expense_list.unapplove")
end

json.ability do
  eappr_is_present = @eappr.present?  # 承認が存在するなら正
  renewal = can? :renewal, @eappr
  reapproval = can? :reapproval, @eappr
  ex_create = can? :ex_create, @eappr

  json.show_expense_approval_new      !eappr_is_present                  # 経費申請
  json.reapproval                     eappr_is_present && reapproval     # 再申請
  json.show_expense_new               !eappr_is_present                  # 経費新規作成
  json.add_expense                    eappr_is_present && ex_create      # 経費追加
  json.destroy                        !eappr_is_present || renewal       # 経費削除
  json.invalid_approval               eappr_is_present && renewal        # 申請取り消し
  json.show_history                   !eappr_is_present                  # 経費履歴
end
