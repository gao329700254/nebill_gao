require 'rails_helper'

RSpec.feature 'Bill Show Page', js: true do
  given!(:user) { create(:user) }
  background { login user, with_capybara: true }

  given(:bill) { create(:bill) }
  background { visit bill_show_path(bill) }

  subject { page }

  scenario 'show' do
    is_expected.to have_header_title '請求情報'
  end

  describe 'form' do
    subject { find('.bill_show__form') }

    scenario 'should show bill attributes' do
      is_expected.to     have_field 'key'           , disabled: true, with: bill.key
      is_expected.to     have_field 'amount'        , disabled: true, with: bill.amount.to_s(:delimited)
      is_expected.to     have_field 'delivery_on'   , disabled: true, with: bill.delivery_on
      is_expected.to     have_field 'acceptance_on' , disabled: true, with: bill.acceptance_on
      is_expected.to     have_field 'payment_on'    , disabled: true, with: bill.payment_on
      is_expected.to     have_field 'bill_on'       , disabled: true, with: bill.bill_on
      is_expected.to     have_field 'deposit_on'    , disabled: true, with: bill.deposit_on
      is_expected.to     have_field 'memo'          , disabled: true, with: bill.memo
      is_expected.to     have_button '編集'
      is_expected.to     have_button 'ダウンロード'
      is_expected.not_to have_button 'キャンセル'
      is_expected.not_to have_button '更新'
    end

    context 'when click edit button' do
      background { click_button '編集' }

      scenario 'should have edit bill fields' do
        is_expected.to     have_field 'key'           , disabled: false, with: bill.key
        is_expected.to     have_field 'amount'        , disabled: false, with: bill.amount.to_s(:delimited)
        is_expected.to     have_field 'delivery_on'   , disabled: false, with: bill.delivery_on
        is_expected.to     have_field 'acceptance_on' , disabled: false, with: bill.acceptance_on
        is_expected.to     have_field 'payment_on'    , disabled: false, with: bill.payment_on
        is_expected.to     have_field 'bill_on'       , disabled: false, with: bill.bill_on
        is_expected.to     have_field 'deposit_on'    , disabled: false, with: bill.deposit_on
        is_expected.to     have_field 'memo'          , disabled: false, with: bill.memo
        is_expected.not_to have_button '編集'
        is_expected.not_to have_button 'ダウンロード'
        is_expected.to     have_button 'キャンセル'
        is_expected.to     have_button '更新'
      end

      scenario 'should do not update when click cancel button' do
        original_key            = bill.key
        original_amount         = bill.amount
        original_delivery_on    = bill.delivery_on
        original_acceptance_on  = bill.acceptance_on
        original_payment_on     = bill.payment_on
        original_bill_on        = bill.bill_on
        original_deposit_on     = bill.deposit_on
        original_memo           = bill.memo

        fill_in :key            , with: '0000001'
        fill_in :amount         , with: 101_010
        fill_in :delivery_on    , with: '2016-01-01'
        fill_in :acceptance_on  , with: '2016-01-02'
        fill_in :payment_on     , with: '2016-01-03'
        fill_in :bill_on        , with: '2016-01-04'
        fill_in :deposit_on     , with: '2016-01-05'
        fill_in :memo           , with: 'memo'

        expect do
          click_button 'キャンセル'
          wait_for_ajax
        end.not_to change { bill.reload && bill.updated_at }

        is_expected.to     have_field 'key'           , disabled: true, with: original_key
        is_expected.to     have_field 'amount'        , disabled: true, with: original_amount.to_s(:delimited)
        is_expected.to     have_field 'delivery_on'   , disabled: true, with: original_delivery_on
        is_expected.to     have_field 'acceptance_on' , disabled: true, with: original_acceptance_on
        is_expected.to     have_field 'payment_on'    , disabled: true, with: original_payment_on
        is_expected.to     have_field 'bill_on'       , disabled: true, with: original_bill_on
        is_expected.to     have_field 'deposit_on'    , disabled: true, with: original_deposit_on
        is_expected.to     have_field 'memo'          , disabled: true, with: original_memo
      end

      scenario 'should update when click submit button with correct values' do
        fill_in :key            , with: '0000001'
        fill_in :amount         , with: 101_010
        fill_in :delivery_on    , with: '2016-01-01'
        fill_in :acceptance_on  , with: '2016-01-02'
        fill_in :payment_on     , with: '2016-01-03'
        fill_in :bill_on        , with: '2016-01-04'
        fill_in :deposit_on     , with: '2016-01-05'
        fill_in :memo           , with: 'memo'

        expect do
          click_button '更新'
          wait_for_ajax
        end.to change { bill.reload && bill.updated_at }

        is_expected.to     have_field 'key'           , disabled: true, with: '0000001'
        is_expected.to     have_field 'amount'        , disabled: true, with: 101_010.to_s(:delimited)
        is_expected.to     have_field 'delivery_on'   , disabled: true, with: '2016-01-01'
        is_expected.to     have_field 'acceptance_on' , disabled: true, with: '2016-01-02'
        is_expected.to     have_field 'payment_on'    , disabled: true, with: '2016-01-03'
        is_expected.to     have_field 'bill_on'       , disabled: true, with: '2016-01-04'
        is_expected.to     have_field 'deposit_on'    , disabled: true, with: '2016-01-05'
        is_expected.to     have_field 'memo'          , disabled: true, with: 'memo'
      end

      scenario 'should not update when click submit button with uncorrect values' do
        fill_in :key            , with: '  '
        fill_in :amount         , with: 101_010
        fill_in :delivery_on    , with: '2016-01-01'
        fill_in :acceptance_on  , with: '2016-01-02'
        fill_in :payment_on     , with: '2016-01-03'
        fill_in :bill_on        , with: '2016-01-04'
        fill_in :deposit_on     , with: '2016-01-05'
        fill_in :memo           , with: 'memo'

        expect do
          click_button '更新'
          wait_for_ajax
        end.not_to change { bill.reload && bill.updated_at }

        is_expected.to     have_field 'key'           , disabled: false, with: '  '
        is_expected.to     have_field 'amount'        , disabled: false, with: 101_010.to_s(:delimited)
        is_expected.to     have_field 'delivery_on'   , disabled: false, with: '2016-01-01'
        is_expected.to     have_field 'acceptance_on' , disabled: false, with: '2016-01-02'
        is_expected.to     have_field 'payment_on'    , disabled: false, with: '2016-01-03'
        is_expected.to     have_field 'bill_on'       , disabled: false, with: '2016-01-04'
        is_expected.to     have_field 'deposit_on'    , disabled: false, with: '2016-01-05'
        is_expected.to     have_field 'memo'          , disabled: false, with: 'memo'
      end

      scenario 'should not update when click submit button with uncorrect bill_on predate delivery_on' do
        fill_in :key            , with: '0000002'
        fill_in :amount         , with: 101_010
        fill_in :delivery_on    , with: '2016-01-01'
        fill_in :acceptance_on  , with: '2016-01-02'
        fill_in :payment_on     , with: '2016-01-03'
        fill_in :bill_on        , with: '2015-12-31'
        fill_in :deposit_on     , with: '2016-01-05'
        fill_in :memo           , with: 'memo'

        expect do
          click_button '更新'
          wait_for_ajax
        end.not_to change { bill.reload && bill.updated_at }

        is_expected.to     have_field 'key'           , disabled: false, with: '0000002'
        is_expected.to     have_field 'amount'        , disabled: false, with: 101_010.to_s(:delimited)
        is_expected.to     have_field 'delivery_on'   , disabled: false, with: '2016-01-01'
        is_expected.to     have_field 'acceptance_on' , disabled: false, with: '2016-01-02'
        is_expected.to     have_field 'payment_on'    , disabled: false, with: '2016-01-03'
        is_expected.to     have_field 'bill_on'       , disabled: false, with: '2015-12-31'
        is_expected.to     have_field 'deposit_on'    , disabled: false, with: '2016-01-05'
        is_expected.to     have_field 'memo'          , disabled: false, with: 'memo'
      end

      scenario 'should not update when click submit button with uncorrect bill_on predate acceptance_on' do
        fill_in :key            , with: '0000002'
        fill_in :amount         , with: 101_010
        fill_in :delivery_on    , with: '2016-01-01'
        fill_in :acceptance_on  , with: '2016-01-02'
        fill_in :payment_on     , with: '2016-01-03'
        fill_in :bill_on        , with: '2016-01-01'
        fill_in :deposit_on     , with: '2016-01-05'
        fill_in :memo           , with: 'memo'

        expect do
          click_button '更新'
          wait_for_ajax
        end.not_to change { bill.reload && bill.updated_at }

        is_expected.to     have_field 'key'           , disabled: false, with: '0000002'
        is_expected.to     have_field 'amount'        , disabled: false, with: 101_010.to_s(:delimited)
        is_expected.to     have_field 'delivery_on'   , disabled: false, with: '2016-01-01'
        is_expected.to     have_field 'acceptance_on' , disabled: false, with: '2016-01-02'
        is_expected.to     have_field 'payment_on'    , disabled: false, with: '2016-01-03'
        is_expected.to     have_field 'bill_on'       , disabled: false, with: '2016-01-01'
        is_expected.to     have_field 'deposit_on'    , disabled: false, with: '2016-01-05'
        is_expected.to     have_field 'memo'          , disabled: false, with: 'memo'
      end
    end
  end

  describe 'download' do
    let(:file_name) { ['請求書', bill.project.billing_company_name, bill.key].compact.join("_") + '.xlsx' }

    context 'when click download button' do
      it 'should download an excel file' do
        click_button 'ダウンロード'
        expect(page.response_headers['Content-Disposition']).to include(file_name)
        expect(page.response_headers['Content-Type']).to eq('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      end
    end
  end
end
