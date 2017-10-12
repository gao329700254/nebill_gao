require 'rails_helper'

RSpec.feature 'Bill Show Page', js: true, versioning: true do
  given!(:user) { create(:user) }
  background { login user, with_capybara: true }

  given(:bill) { create(:bill) }
  given!(:user1) { create(:user, :with_bill, bill: bill) }
  given!(:user2) { create(:user, :with_bill, bill: bill) }
  given!(:other_user1) { create(:user) }
  given!(:other_user2) { create(:user) }
  given!(:partner1) { create(:partner, :with_bill, bill: bill, company_name: "cuon", id: 99_999) }
  given!(:partner2) { create(:partner, :with_bill, bill: bill, company_name: "cuon", id: 100_000) }
  given!(:member1) { Member.find_by(id: partner1.members.ids) }
  given!(:member2) { Member.find_by(id: partner2.members.ids) }
  given!(:other_partner1) { create(:partner) }
  given!(:other_partner2) { create(:partner) }
  background { visit bill_show_path(bill) }

  subject { page }

  scenario 'show' do
    is_expected.to have_header_title '請求情報'
    is_expected.to have_content '最終更新日時: ' + I18n.l(bill.updated_at.in_time_zone('Tokyo'))
  end

  describe 'form' do
    subject { find('.bill_show__form__container__group') }

    scenario 'should show bill attributes' do
      is_expected.to     have_field 'cd'            , disabled: true, with: bill.cd
      is_expected.to     have_field 'amount'        , disabled: true, with: bill.amount.to_s(:delimited)
      is_expected.to     have_field 'delivery_on'   , disabled: true, with: bill.delivery_on
      is_expected.to     have_field 'acceptance_on' , disabled: true, with: bill.acceptance_on
      is_expected.to     have_field 'payment_type'  , disabled: true, with: bill.payment_type
      is_expected.to     have_field 'bill_on'       , disabled: true, with: bill.bill_on
      is_expected.to     have_field 'deposit_on'    , disabled: true, with: bill.deposit_on
      is_expected.to     have_field 'memo'          , disabled: true, with: bill.memo
      is_expected.to     have_button '編集'
      is_expected.to     have_link 'Excel'
      is_expected.to     have_link 'PDF'
      is_expected.to     have_button '削除'
      is_expected.not_to have_button 'キャンセル'
      is_expected.not_to have_button '更新'
    end

    context 'when click edit button' do
      background { click_button '編集' }

      scenario 'should have edit bill fields' do
        is_expected.to     have_field 'cd'            , disabled: false, with: bill.cd
        is_expected.to     have_field 'amount'        , disabled: false, with: bill.amount.to_s(:delimited)
        is_expected.to     have_field 'delivery_on'   , disabled: false, with: bill.delivery_on
        is_expected.to     have_field 'acceptance_on' , disabled: false, with: bill.acceptance_on
        is_expected.to     have_field 'payment_type'  , disabled: false, with: bill.payment_type
        is_expected.to     have_field 'bill_on'       , disabled: false, with: bill.bill_on
        is_expected.to     have_field 'deposit_on'    , disabled: false, with: bill.deposit_on
        is_expected.to     have_field 'memo'          , disabled: false, with: bill.memo
        is_expected.not_to have_button '編集'
        is_expected.not_to have_button 'Excel'
        is_expected.not_to have_button 'PDF'
        is_expected.not_to have_button '削除'
        is_expected.to     have_button 'キャンセル'
        is_expected.to     have_button '更新'
      end

      scenario 'should do not update when click cancel button' do
        original_cd             = bill.cd
        original_amount         = bill.amount
        original_delivery_on    = bill.delivery_on
        original_acceptance_on  = bill.acceptance_on
        original_payment_type   = bill.payment_type
        original_bill_on        = bill.bill_on
        original_deposit_on     = bill.deposit_on
        original_memo           = bill.memo

        fill_in :cd              , with: '0000001'
        fill_in :amount          , with: 101_010
        fill_in :delivery_on     , with: '2016-01-01'
        fill_in :acceptance_on   , with: '2016-01-02'
        select  '15日締め翌月末払い', from: :payment_type
        fill_in :bill_on         , with: '2016-01-04'
        fill_in :deposit_on      , with: '2016-01-05'
        fill_in :memo            , with: 'memo'

        expect do
          click_button 'キャンセル'
          wait_for_ajax
        end.not_to change { bill.reload && bill.updated_at }

        is_expected.to     have_field 'cd'            , disabled: true, with: original_cd
        is_expected.to     have_field 'amount'        , disabled: true, with: original_amount.to_s(:delimited)
        is_expected.to     have_field 'delivery_on'   , disabled: true, with: original_delivery_on
        is_expected.to     have_field 'acceptance_on' , disabled: true, with: original_acceptance_on
        is_expected.to     have_field 'payment_type'  , disabled: true, with: original_payment_type
        is_expected.to     have_field 'bill_on'       , disabled: true, with: original_bill_on
        is_expected.to     have_field 'deposit_on'    , disabled: true, with: original_deposit_on
        is_expected.to     have_field 'memo'          , disabled: true, with: original_memo
      end

      scenario 'should update when click submit button with correct values' do
        sleep 1
        fill_in :cd              , with: '0000001'
        fill_in :amount          , with: 101_010
        fill_in :delivery_on     , with: '2016-01-01'
        fill_in :acceptance_on   , with: '2016-01-02'
        select  '15日締め翌月末払い', from: :payment_type
        fill_in :bill_on         , with: '2016-01-04'
        fill_in :deposit_on      , with: '2016-01-05'
        fill_in :memo            , with: 'memo'

        expect do
          click_button '更新'
          wait_for_ajax
        end.to change { bill.reload && bill.updated_at }

        is_expected.to     have_field 'cd'            , disabled: true, with: '0000001'
        is_expected.to     have_field 'amount'        , disabled: true, with: 101_010.to_s(:delimited)
        is_expected.to     have_field 'delivery_on'   , disabled: true, with: '2016-01-01'
        is_expected.to     have_field 'acceptance_on' , disabled: true, with: '2016-01-02'
        is_expected.to     have_field 'payment_type'  , disabled: true, with: 'bill_on_15th_and_payment_on_end_of_next_month'
        is_expected.to     have_field 'bill_on'       , disabled: true, with: '2016-01-04'
        is_expected.to     have_field 'deposit_on'    , disabled: true, with: '2016-01-05'
        is_expected.to     have_field 'memo'          , disabled: true, with: 'memo'
      end

      scenario 'should not update when click submit button with uncorrect values' do
        sleep 1
        fill_in :cd              , with: '  '
        fill_in :amount          , with: 101_010
        fill_in :delivery_on     , with: '2016-01-01'
        fill_in :acceptance_on   , with: '2016-01-02'
        select  '15日締め翌月末払い', from: :payment_type
        fill_in :bill_on         , with: '2016-01-04'
        fill_in :deposit_on      , with: '2016-01-05'
        fill_in :memo            , with: 'memo'

        expect do
          click_button '更新'
          wait_for_ajax
        end.not_to change { bill.reload && bill.updated_at }

        is_expected.to     have_field 'cd'            , disabled: false, with: '  '
        is_expected.to     have_field 'amount'        , disabled: false, with: 101_010.to_s(:delimited)
        is_expected.to     have_field 'delivery_on'   , disabled: false, with: '2016-01-01'
        is_expected.to     have_field 'acceptance_on' , disabled: false, with: '2016-01-02'
        is_expected.to     have_field 'payment_type'  , disabled: false, with: 'bill_on_15th_and_payment_on_end_of_next_month'
        is_expected.to     have_field 'bill_on'       , disabled: false, with: '2016-01-04'
        is_expected.to     have_field 'deposit_on'    , disabled: false, with: '2016-01-05'
        is_expected.to     have_field 'memo'          , disabled: false, with: 'memo'
      end

      scenario 'should not update when click submit button with uncorrect bill_on predate delivery_on' do
        sleep 1
        fill_in :cd              , with: '0000002'
        fill_in :amount          , with: 101_010
        fill_in :delivery_on     , with: '2016-01-01'
        fill_in :acceptance_on   , with: '2016-01-02'
        select  '15日締め翌月末払い', from: :payment_type
        fill_in :bill_on         , with: '2015-12-31'
        fill_in :deposit_on      , with: '2016-01-05'
        fill_in :memo            , with: 'memo'

        expect do
          click_button '更新'
          wait_for_ajax
        end.not_to change { bill.reload && bill.updated_at }

        is_expected.to     have_field 'cd'            , disabled: false, with: '0000002'
        is_expected.to     have_field 'amount'        , disabled: false, with: 101_010.to_s(:delimited)
        is_expected.to     have_field 'delivery_on'   , disabled: false, with: '2016-01-01'
        is_expected.to     have_field 'acceptance_on' , disabled: false, with: '2016-01-02'
        is_expected.to     have_field 'payment_type'  , disabled: false, with: 'bill_on_15th_and_payment_on_end_of_next_month'
        is_expected.to     have_field 'bill_on'       , disabled: false, with: '2015-12-31'
        is_expected.to     have_field 'deposit_on'    , disabled: false, with: '2016-01-05'
        is_expected.to     have_field 'memo'          , disabled: false, with: 'memo'
      end

      scenario 'should not update when click submit button with uncorrect bill_on predate acceptance_on' do
        sleep 1
        fill_in :cd              , with: '0000002'
        fill_in :amount          , with: 101_010
        fill_in :delivery_on     , with: '2016-01-01'
        fill_in :acceptance_on   , with: '2016-01-02'
        select  '15日締め翌月末払い', from: :payment_type
        fill_in :bill_on         , with: '2016-01-01'
        fill_in :deposit_on      , with: '2016-01-05'
        fill_in :memo            , with: 'memo'

        expect do
          click_button '更新'
          wait_for_ajax
        end.not_to change { bill.reload && bill.updated_at }

        is_expected.to     have_field 'cd'            , disabled: false, with: '0000002'
        is_expected.to     have_field 'amount'        , disabled: false, with: 101_010.to_s(:delimited)
        is_expected.to     have_field 'delivery_on'   , disabled: false, with: '2016-01-01'
        is_expected.to     have_field 'acceptance_on' , disabled: false, with: '2016-01-02'
        is_expected.to     have_field 'payment_type'  , disabled: false, with: 'bill_on_15th_and_payment_on_end_of_next_month'
        is_expected.to     have_field 'bill_on'       , disabled: false, with: '2016-01-01'
        is_expected.to     have_field 'deposit_on'    , disabled: false, with: '2016-01-05'
        is_expected.to     have_field 'memo'          , disabled: false, with: 'memo'
      end

      scenario 'should only have download button when deposit_on is filled' do
        sleep 1
        fill_in :cd              , with: '0000001'
        fill_in :amount          , with: 101_010
        fill_in :delivery_on     , with: '2016-01-01'
        fill_in :acceptance_on   , with: '2016-01-02'
        select  '15日締め翌月末払い', from: :payment_type
        fill_in :bill_on         , with: '2016-01-04'
        fill_in :deposit_on      , with: '2016-01-05'
        fill_in :memo            , with: 'memo'

        expect do
          click_button '更新'
          wait_for_ajax
        end.to change { bill.reload && bill.updated_at }

        is_expected.to     have_field 'cd'            , disabled: true, with: '0000001'
        is_expected.to     have_field 'amount'        , disabled: true, with: 101_010.to_s(:delimited)
        is_expected.to     have_field 'delivery_on'   , disabled: true, with: '2016-01-01'
        is_expected.to     have_field 'acceptance_on' , disabled: true, with: '2016-01-02'
        is_expected.to     have_field 'payment_type'  , disabled: true, with: 'bill_on_15th_and_payment_on_end_of_next_month'
        is_expected.to     have_field 'bill_on'       , disabled: true, with: '2016-01-04'
        is_expected.to     have_field 'deposit_on'    , disabled: true, with: '2016-01-05'
        is_expected.to     have_field 'memo'          , disabled: true, with: 'memo'
        is_expected.to     have_link  'Excel'
        is_expected.to     have_link  'PDF'
        is_expected.not_to have_button '編集'
        is_expected.not_to have_button '削除'
        is_expected.not_to have_button 'キャンセル'
        is_expected.not_to have_button '更新'
      end
    end
  end

  describe 'download' do
    context 'when click Excel button' do
      let(:file_name) { ['請求書', bill.project.billing_company_name, bill.cd].compact.join("_") + '.xlsx' }

      it 'should download an excel file' do
        click_on 'Excel'
        expect(page.response_headers['Content-Disposition']).to include(file_name)
        expect(page.response_headers['Content-Type']).to eq('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      end
    end

    context 'when click PDF button' do
      let(:file_name) { ['請求書', bill.project.billing_company_name, bill.cd].compact.join("_") + '.pdf' }

      it 'should download a PDF file' do
        click_on 'PDF'
        expect(page.response_headers['Content-Disposition']).to include(file_name)
        expect(page.response_headers['Content-Type']).to eq('application/pdf')
      end
    end
  end

  describe 'delete' do
    context 'when click delete button' do
      scenario 'and accept the confirm' do
        page.accept_confirm('本当に削除してよろしいですか？') do
          click_button '削除'
          wait_for_ajax
        end
        sleep 1
        expect(current_path).to eq bill_list_path
        expect(page).not_to have_content bill.cd
      end

      scenario 'and dismiss the confirm' do
        page.dismiss_confirm do
          click_button '削除'
        end

        expect(current_path).to eq bill_show_path(bill)
        expect(page).to have_field 'cd', disabled: true, with: bill.cd
      end
    end
  end

  describe 'Member List View' do
    describe 'User List' do
      subject { find('.user') }

      scenario 'Show' do
        is_expected.to have_content '名前'
        is_expected.to have_content 'メールアドレス'

        is_expected.to have_content user1.name
        is_expected.to have_content user1.email
        is_expected.to have_content user2.name
        is_expected.to have_content user2.email

        is_expected.not_to have_content other_user1.name
        is_expected.not_to have_content other_user1.email
        is_expected.not_to have_content other_user2.name
        is_expected.not_to have_content other_user2.email

        is_expected.to have_field 'user', with: ''
        is_expected.to have_button '登録'
        is_expected.not_to have_button '削除'
      end

      scenario 'select user and click submit button' do
        select other_user1.name, from: :user

        expect do
          within('.user') { click_button '登録' }
          wait_for_ajax
        end.to change(Member, :count).by(1)

        expect(page).to have_content '最終更新日時: ' + I18n.l(Member.last.updated_at.in_time_zone('Tokyo'))
      end

      context 'when select users' do
        before { within("#user-#{user1.id}") { check 'selected' } }

        scenario 'should appear the delete button' do
          is_expected.to have_button '削除'
        end

        scenario 'and click delete button' do
          expect do
            within('.user') { click_button '削除' }
            wait_for_ajax
          end.to change(Member, :count).by(-1)

          is_expected.not_to have_content user1.name
          is_expected.to     have_content user2.name

          expect(page).to have_content '最終更新日時: ' + I18n.l(Version.last.created_at.in_time_zone('Tokyo'))
        end
      end
    end

    describe 'Partner List' do
      subject { find('.bill_show__form__member_list__partner') }

      describe 'Partner Member' do
        scenario 'should show partner attributes' do
          is_expected.to have_content '名前'
          is_expected.to have_content '単価'
          is_expected.to have_content '稼働時間'
          is_expected.to have_content '下限'
          is_expected.to have_content '上限'

          is_expected.to have_field 'name'              , disabled: true, with: partner1.name
          is_expected.to have_field 'unit_price'        , disabled: true, with: partner1.members[0].unit_price
          is_expected.to have_field 'working_rate'      , disabled: true, with: partner1.members[0].working_rate
          is_expected.to have_field 'min_limit_time'    , disabled: true, with: partner1.members[0].min_limit_time
          is_expected.to have_field 'max_limit_time'    , disabled: true, with: partner1.members[0].max_limit_time
          is_expected.to have_field 'name'              , disabled: true, with: partner2.name
          is_expected.to have_field 'unit_price'        , disabled: true, with: partner2.members[0].unit_price
          is_expected.to have_field 'working_rate'      , disabled: true, with: partner2.members[0].working_rate
          is_expected.to have_field 'min_limit_time'    , disabled: true, with: partner2.members[0].min_limit_time
          is_expected.to have_field 'max_limit_time'    , disabled: true, with: partner2.members[0].max_limit_time

          is_expected.not_to have_field 'name'          , with: other_partner1.name
          is_expected.not_to have_field 'name'          , with: other_partner2.name

          is_expected.to     have_field 'partner'           , with: ''
          is_expected.to     have_field 'new_unit_price'    , with: ''
          is_expected.to     have_field 'new_working_rate'  , with: ''
          is_expected.to     have_field 'new_min_limit_time', with: ''
          is_expected.to     have_field 'new_max_limit_time', with: ''
          is_expected.to     have_button '登録'
          is_expected.to     have_button 'パートナーを新規登録'
          is_expected.not_to have_button '編集'
          is_expected.not_to have_button 'キャンセル'
          is_expected.not_to have_button '更新'
          is_expected.not_to have_button '削除'
        end
      end

      describe 'when select partners' do
        before { within("#partner-#{partner1.id}") { check 'selected' } }
        before { within("#partner-#{partner2.id}") { check 'selected' } }

        scenario 'should appear the edit button and delete button' do
          is_expected.to have_button '編集'
          is_expected.to have_button '削除'
        end

        describe 'and click edit button' do
          background { within('.bill_show__form__member_list__partner') { click_button '編集' } }

          scenario 'should have edit partner fields' do
            is_expected.to     have_field 'name'              , disabled: false, with: partner1.name
            is_expected.to     have_field 'unit_price'        , disabled: false, with: partner1.members[0].unit_price
            is_expected.to     have_field 'working_rate'      , disabled: false, with: partner1.members[0].working_rate
            is_expected.to     have_field 'min_limit_time'    , disabled: false, with: partner1.members[0].min_limit_time
            is_expected.to     have_field 'max_limit_time'    , disabled: false, with: partner1.members[0].max_limit_time
            is_expected.to     have_field 'name'              , disabled: false, with: partner2.name
            is_expected.to     have_field 'unit_price'        , disabled: false, with: partner2.members[0].unit_price
            is_expected.to     have_field 'working_rate'      , disabled: false, with: partner2.members[0].working_rate
            is_expected.to     have_field 'min_limit_time'    , disabled: false, with: partner2.members[0].min_limit_time
            is_expected.to     have_field 'max_limit_time'    , disabled: false, with: partner2.members[0].max_limit_time
            is_expected.to     have_button '登録'
            is_expected.to     have_button 'パートナーを新規登録'
            is_expected.not_to have_button '編集'
            is_expected.to     have_button 'キャンセル'
            is_expected.to     have_button '更新'
            is_expected.not_to have_button '削除'
          end

          scenario 'should not update when click cancel button' do
            partner_1_original_name           = partner1.name
            partner_1_original_unit_price     = partner1.members[0].unit_price
            partner_1_original_working_rate   = partner1.members[0].working_rate
            partner_1_original_min_limit_time = partner1.members[0].min_limit_time
            partner_1_original_max_limit_time = partner1.members[0].max_limit_time
            partner_2_original_name           = partner2.name
            partner_2_original_unit_price     = partner2.members[0].unit_price
            partner_2_original_working_rate   = partner2.members[0].working_rate
            partner_2_original_min_limit_time = partner2.members[0].min_limit_time
            partner_2_original_max_limit_time = partner2.members[0].max_limit_time

            within("#partner-#{partner1.id}") do
              fill_in :name           , with: 'test1 name'
              fill_in :unit_price     , with: '1'
              fill_in :working_rate   , with: '2'
              fill_in :min_limit_time , with: '3'
              fill_in :max_limit_time , with: '4'
            end

            within("#partner-#{partner2.id}") do
              fill_in :name           , with: 'test2 name'
              fill_in :unit_price     , with: '5'
              fill_in :working_rate   , with: '6'
              fill_in :min_limit_time , with: '7'
              fill_in :max_limit_time , with: '8'
            end

            expect do
              click_button 'キャンセル'
              wait_for_ajax
            end.not_to change { member1.reload && member2.reload && member1.updated_at && member2.updated_at }

            is_expected.to     have_field 'name'              , disabled: true, with: partner_1_original_name
            is_expected.to     have_field 'unit_price'        , disabled: true, with: partner_1_original_unit_price
            is_expected.to     have_field 'working_rate'      , disabled: true, with: partner_1_original_working_rate
            is_expected.to     have_field 'min_limit_time'    , disabled: true, with: partner_1_original_min_limit_time
            is_expected.to     have_field 'max_limit_time'    , disabled: true, with: partner_1_original_max_limit_time
            is_expected.to     have_field 'name'              , disabled: true, with: partner_2_original_name
            is_expected.to     have_field 'unit_price'        , disabled: true, with: partner_2_original_unit_price
            is_expected.to     have_field 'working_rate'      , disabled: true, with: partner_2_original_working_rate
            is_expected.to     have_field 'min_limit_time'    , disabled: true, with: partner_2_original_min_limit_time
            is_expected.to     have_field 'max_limit_time'    , disabled: true, with: partner_2_original_max_limit_time
            is_expected.to     have_button '登録'
            is_expected.to     have_button 'パートナーを新規登録'
            is_expected.not_to have_button '編集'
            is_expected.not_to have_button 'キャンセル'
            is_expected.not_to have_button '更新'
            is_expected.not_to have_button '削除'
          end

          describe 'and when partner1: correct, partner2: correct' do
            scenario 'both partners should update with correct values' do
              within("#partner-#{partner1.id}") do
                fill_in :name           , with: 'test1 name'
                fill_in :unit_price     , with: '1'
                fill_in :working_rate   , with: '2'
                fill_in :min_limit_time , with: '3'
                fill_in :max_limit_time , with: '4'
              end

              within("#partner-#{partner2.id}") do
                fill_in :name           , with: 'test2 name'
                fill_in :unit_price     , with: '5'
                fill_in :working_rate   , with: '6'
                fill_in :min_limit_time , with: '7'
                fill_in :max_limit_time , with: '8'
              end

              expect do
                click_button '更新'
                wait_for_ajax
              end.to change { member1.reload && member2.reload && member1.updated_at && member2.updated_at }

              within("#partner-#{partner1.id}") do
                expect(page).to     have_field 'name'            , disabled: true, with: 'test1 name'
                expect(page).to     have_field 'unit_price'      , disabled: true, with: '1'
                expect(page).to     have_field 'working_rate'    , disabled: true, with: '2'
                expect(page).to     have_field 'min_limit_time'  , disabled: true, with: '3'
                expect(page).to     have_field 'max_limit_time'  , disabled: true, with: '4'
              end

              within("#partner-#{partner2.id}") do
                expect(page).to     have_field 'name'            , disabled: true, with: 'test2 name'
                expect(page).to     have_field 'unit_price'      , disabled: true, with: '5'
                expect(page).to     have_field 'working_rate'    , disabled: true, with: '6'
                expect(page).to     have_field 'min_limit_time'  , disabled: true, with: '7'
                expect(page).to     have_field 'max_limit_time'  , disabled: true, with: '8'
              end

              is_expected.to     have_button '登録'
              is_expected.to     have_button 'パートナーを新規登録'
              is_expected.not_to have_button '編集'
              is_expected.not_to have_button 'キャンセル'
              is_expected.not_to have_button '更新'
              is_expected.not_to have_button '削除'

              expect(page).to have_content '最終更新日時: ' + I18n.l(Version.last.created_at.in_time_zone('Tokyo'))
            end
          end

          describe 'and when partner1: incorrect, partner2: correct' do
            scenario 'only one partner should update with correct values' do
              within("#partner-#{partner1.id}") do
                fill_in :name           , with: '  '
                fill_in :unit_price     , with: '1'
                fill_in :working_rate   , with: '2'
                fill_in :min_limit_time , with: '3'
                fill_in :max_limit_time , with: '4'
              end

              within("#partner-#{partner2.id}") do
                fill_in :name           , with: 'test2 name'
                fill_in :unit_price     , with: '5'
                fill_in :working_rate   , with: '6'
                fill_in :min_limit_time , with: '7'
                fill_in :max_limit_time , with: '8'
              end

              expect do
                click_button '更新'
                wait_for_ajax
              end.not_to change { member1.reload && member1.updated_at }
              member2.reload && member2.updated_at

              within("#partner-#{partner1.id}") do
                expect(page).to     have_field 'name'              , disabled: false, with: partner1.name
                expect(page).to     have_field 'unit_price'        , disabled: false, with: partner1.members[0].unit_price
                expect(page).to     have_field 'working_rate'      , disabled: false, with: partner1.members[0].working_rate
                expect(page).to     have_field 'min_limit_time'    , disabled: false, with: partner1.members[0].min_limit_time
                expect(page).to     have_field 'max_limit_time'    , disabled: false, with: partner1.members[0].max_limit_time
              end

              within("#partner-#{partner2.id}") do
                expect(page).to     have_field 'name'            , disabled: true, with: 'test2 name'
                expect(page).to     have_field 'unit_price'      , disabled: true, with: '5'
                expect(page).to     have_field 'working_rate'    , disabled: true, with: '6'
                expect(page).to     have_field 'min_limit_time'  , disabled: true, with: '7'
                expect(page).to     have_field 'max_limit_time'  , disabled: true, with: '8'
              end

              is_expected.to     have_button '登録'
              is_expected.to     have_button 'パートナーを新規登録'
              is_expected.not_to have_button '編集'
              is_expected.to     have_button 'キャンセル'
              is_expected.to     have_button '更新'
              is_expected.not_to have_button '削除'
              expect(page).to have_content '最終更新日時: ' + I18n.l(Version.last.created_at.in_time_zone('Tokyo'))
            end

            describe 'and when partner1: correct' do
              scenario 'partner should update with correct values' do
                within("#partner-#{partner1.id}") do
                  fill_in :name           , with: 'test1 name'
                  fill_in :unit_price     , with: '1'
                  fill_in :working_rate   , with: '2'
                  fill_in :min_limit_time , with: '3'
                  fill_in :max_limit_time , with: '4'
                end

                expect do
                  click_button '更新'
                  wait_for_ajax
                end.to change { member1.reload && member1.updated_at }

                within("#partner-#{partner1.id}") do
                  expect(page).to     have_field 'name'            , disabled: true, with: 'test1 name'
                  expect(page).to     have_field 'unit_price'      , disabled: true, with: '1'
                  expect(page).to     have_field 'working_rate'    , disabled: true, with: '2'
                  expect(page).to     have_field 'min_limit_time'  , disabled: true, with: '3'
                  expect(page).to     have_field 'max_limit_time'  , disabled: true, with: '4'
                end

                expect(page).to have_content '最終更新日時: ' + I18n.l(Version.last.created_at.in_time_zone('Tokyo'))
              end
            end
          end

          describe 'and when partner1: incorrect, partner2: incorrect' do
            scenario 'both partners should not update with uncorrect values' do
              within("#partner-#{partner1.id}") do
                fill_in :name           , with: '  '
                fill_in :unit_price     , with: '1'
                fill_in :working_rate   , with: '2'
                fill_in :min_limit_time , with: '3'
                fill_in :max_limit_time , with: '4'
              end

              within("#partner-#{partner2.id}") do
                fill_in :name           , with: '  '
                fill_in :unit_price     , with: '5'
                fill_in :working_rate   , with: '6'
                fill_in :min_limit_time , with: '7'
                fill_in :max_limit_time , with: '8'
              end

              expect do
                click_button '更新'
                wait_for_ajax
              end.not_to change { member1.reload && member2.reload && member1.updated_at && member2.updated_at }

              within("#partner-#{partner1.id}") do
                expect(page).to     have_field 'name'              , disabled: false, with: partner1.name
                expect(page).to     have_field 'unit_price'        , disabled: false, with: partner1.members[0].unit_price
                expect(page).to     have_field 'working_rate'      , disabled: false, with: partner1.members[0].working_rate
                expect(page).to     have_field 'min_limit_time'    , disabled: false, with: partner1.members[0].min_limit_time
                expect(page).to     have_field 'max_limit_time'    , disabled: false, with: partner1.members[0].max_limit_time
              end

              within("#partner-#{partner2.id}") do
                expect(page).to     have_field 'name'              , disabled: false, with: partner2.name
                expect(page).to     have_field 'unit_price'        , disabled: false, with: partner2.members[0].unit_price
                expect(page).to     have_field 'working_rate'      , disabled: false, with: partner2.members[0].working_rate
                expect(page).to     have_field 'min_limit_time'    , disabled: false, with: partner2.members[0].min_limit_time
                expect(page).to     have_field 'max_limit_time'    , disabled: false, with: partner2.members[0].max_limit_time
              end
            end

            describe 'and when partner1: incorrect, partner2: correct' do
              scenario 'only one partner should update with correct values' do
                within("#partner-#{partner1.id}") do
                  fill_in :name           , with: '  '
                  fill_in :unit_price     , with: '1'
                  fill_in :working_rate   , with: '2'
                  fill_in :min_limit_time , with: '3'
                  fill_in :max_limit_time , with: '4'
                end

                within("#partner-#{partner2.id}") do
                  fill_in :name           , with: 'test2 name'
                  fill_in :unit_price     , with: '5'
                  fill_in :working_rate   , with: '6'
                  fill_in :min_limit_time , with: '7'
                  fill_in :max_limit_time , with: '8'
                end

                expect do
                  click_button '更新'
                  wait_for_ajax
                end.not_to change { member1.reload && member1.updated_at }
                member2.reload && member2.updated_at

                within("#partner-#{partner1.id}") do
                  expect(page).to     have_field 'name'              , disabled: false, with: partner1.name
                  expect(page).to     have_field 'unit_price'        , disabled: false, with: partner1.members[0].unit_price
                  expect(page).to     have_field 'working_rate'      , disabled: false, with: partner1.members[0].working_rate
                  expect(page).to     have_field 'min_limit_time'    , disabled: false, with: partner1.members[0].min_limit_time
                  expect(page).to     have_field 'max_limit_time'    , disabled: false, with: partner1.members[0].max_limit_time
                end

                within("#partner-#{partner2.id}") do
                  expect(page).to     have_field 'name'            , disabled: true, with: 'test2 name'
                  expect(page).to     have_field 'unit_price'      , disabled: true, with: '5'
                  expect(page).to     have_field 'working_rate'    , disabled: true, with: '6'
                  expect(page).to     have_field 'min_limit_time'  , disabled: true, with: '7'
                  expect(page).to     have_field 'max_limit_time'  , disabled: true, with: '8'
                end

                expect(page).to have_content '最終更新日時: ' + I18n.l(Version.last.created_at.in_time_zone('Tokyo'))
              end

              describe 'and when partner1: correct' do
                scenario 'partner should update with correct values' do
                  within("#partner-#{partner1.id}") do
                    fill_in :name           , with: 'test1 name'
                    fill_in :unit_price     , with: '1'
                    fill_in :working_rate   , with: '2'
                    fill_in :min_limit_time , with: '3'
                    fill_in :max_limit_time , with: '4'
                  end

                  expect do
                    click_button '更新'
                    wait_for_ajax
                  end.to change { member1.reload && member1.updated_at }

                  within("#partner-#{partner1.id}") do
                    expect(page).to     have_field 'name'            , disabled: true, with: 'test1 name'
                    expect(page).to     have_field 'unit_price'      , disabled: true, with: '1'
                    expect(page).to     have_field 'working_rate'    , disabled: true, with: '2'
                    expect(page).to     have_field 'min_limit_time'  , disabled: true, with: '3'
                    expect(page).to     have_field 'max_limit_time'  , disabled: true, with: '4'
                  end

                  expect(page).to have_content '最終更新日時: ' + I18n.l(Version.last.created_at.in_time_zone('Tokyo'))
                end
              end
            end
          end
        end

        scenario 'and click delete button' do
          expect do
            within('.bill_show__form__member_list__partner') { click_button '削除' }
            wait_for_ajax
          end.to change(Member, :count).by(-2)

          is_expected.not_to have_field 'name', disabled: false, with: partner1.name
          is_expected.not_to have_field 'name', disabled: false, with: partner2.name

          expect(page).to have_content '最終更新日時: ' + I18n.l(Version.last.created_at.in_time_zone('Tokyo'))
        end
      end

      scenario 'select partner and click submit button with correct values' do
        select other_partner1.name, from: :partner
        fill_in :new_unit_price, with: '1'
        fill_in :new_working_rate, with: '0.6'
        fill_in :new_min_limit_time, with: '1'
        fill_in :new_max_limit_time, with: '2'

        expect do
          within('.bill_show__form__member_list__partner') { click_button '登録' }
          wait_for_ajax
        end.to change(Member, :count).by(1)

        expect(page).to have_content '最終更新日時: ' + I18n.l(Version.last.created_at.in_time_zone('Tokyo'))
      end

      scenario 'select partner and click submit button with uncorrect values' do
        select other_partner2.name, from: :partner
        fill_in :new_unit_price, with: '1'
        fill_in :new_working_rate, with: '0.6'
        fill_in :new_min_limit_time, with: '0.2'
        fill_in :new_max_limit_time, with: '0.1'

        expect do
          within('.bill_show__form__member_list__partner') { click_button '登録' }
          wait_for_ajax
        end.not_to change(Member, :count)
      end

      scenario 'show Partner New Modal when click show modal button' do
        expect(page).not_to have_css '.partner_new__outer'
        click_on 'パートナーを新規登録'
        expect(page).to     have_css '.partner_new__outer'
      end

      describe 'Partner New Modal' do
        before { click_on 'パートナーを新規登録' }
        subject { find('.partner_new') }

        scenario 'show' do
          is_expected.to have_content 'パートナーを新規登録'
        end

        describe 'form' do
          scenario 'show' do
            is_expected.to have_field 'cd'
            is_expected.to have_field 'email'
            is_expected.to have_field 'name'
            is_expected.to have_field 'company_name'
            is_expected.to have_field 'address'
            is_expected.to have_field 'zip_code'
            is_expected.to have_field 'phone_number'
            is_expected.to have_button 'キャンセル'
            is_expected.to have_button '登録'
          end

          scenario 'click submit button with correct values' do
            fill_in :cd          , with: 'cd'
            fill_in :email       , with: 'foobar@example.com'
            fill_in :name        , with: 'foo bar'
            fill_in :company_name, with: 'abc'
            fill_in :address     , with: 'address'
            fill_in :zip_code    , with: 'zip_code'
            fill_in :phone_number, with: '1234-5678'

            expect do
              within('.partner_new__form') { click_button '登録' }
              wait_for_ajax
            end.to change(Partner, :count).by(1)

            is_expected.not_to have_css '.partner_new__outer'
          end

          scenario 'click submit button with uncorrect values' do
            fill_in :cd          , with: 'cd'
            fill_in :email       , with: 'foobar@'
            fill_in :name        , with: 'foo bar'
            fill_in :company_name, with: 'abc'
            fill_in :address     , with: 'address'
            fill_in :zip_code    , with: 'zip_code'
            fill_in :phone_number, with: '1234-5678'

            expect do
              within('.partner_new__form') { click_button '登録' }
              wait_for_ajax
            end.not_to change(Partner, :count)

            is_expected.to have_css '.partner_new__outer'
            is_expected.to have_field 'email'       , with: 'foobar@'
            is_expected.to have_field 'name'        , with: 'foo bar'
            is_expected.to have_field 'company_name', with: 'abc'
            is_expected.to have_field 'address'     , with: 'address'
            is_expected.to have_field 'zip_code'    , with: 'zip_code'
            is_expected.to have_field 'phone_number', with: '1234-5678'

          end

          scenario 'click cancel' do
            is_expected.to     have_css '.partner_new__outer'
            click_button 'キャンセル'
            is_expected.not_to have_css '.partner_new__outer'
          end
        end
      end
    end
  end
end
