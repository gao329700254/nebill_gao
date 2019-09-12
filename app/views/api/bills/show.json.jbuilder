json.id                  @bill.id
json.project_id          @bill.project_id
json.cd                  @bill.cd
json.amount              @bill.amount
json.delivery_on         @bill.delivery_on
json.acceptance_on       @bill.acceptance_on
json.payment_type        @bill.payment_type
json.bill_on             @bill.bill_on
json.expected_deposit_on @bill.expected_deposit_on
json.deposit_on          @bill.deposit_on
json.memo                @bill.memo
json.created_at          @bill.created_at
json.updated_at          I18n.l(@last_updated_at.in_time_zone('Tokyo'))
json.whodunnit           '（' + @user.name + '）' if @user
