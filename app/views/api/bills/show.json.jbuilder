json.id                     @bill.id
json.cd                     @bill.cd
json.project_name           @bill.project_name
json.company_name           @bill.company_name
json.amount                 @bill.amount
json.delivery_on            @bill.delivery_on
json.acceptance_on          @bill.acceptance_on
json.payment_type           @bill.payment_type
json.bill_on                @bill.bill_on
json.issue_on               @bill.issue_on
json.expected_deposit_on    @bill.expected_deposit_on
json.deposit_on             @bill.deposit_on
json.memo                   @bill.memo
json.deposit_confirmed_memo @bill.deposit_confirmed_memo
json.status                 @bill.status_i18n
json.expense                @bill.expense
json.require_acceptance     @bill.require_acceptance
json.details                @bill.details.order(:display_order), :id, :content, :amount
json.created_at             @bill.created_at
json.updated_at             I18n.l(@last_updated_at.in_time_zone('Tokyo'))
json.whodunnit              '（' + @user.name + '）' if @user
