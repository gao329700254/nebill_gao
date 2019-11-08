module DefineClassHelper
  def approval_tbl_class(approval)
    approval.disconfirm? || approval.invalid? ? 'approval_list__tbl__body__row approval_list__tbl__body__row--repudiation': 'approval_list__tbl__body__row'
  end
end
