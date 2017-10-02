require 'rails_helper'

RSpec.feature 'Project Show Page', js: true do
  given!(:user) { create(:user) }
  background { login user, with_capybara: true }

  describe 'that is uncontracted project' do
    given!(:project_group1) { create(:project_group, name: 'Group1') }
    given!(:project_group2) { create(:project_group, name: 'Group2') }
    given!(:project) { create(:uncontracted_project, group: project_group1) }
    given!(:user1) { create(:user, :with_project, project: project) }
    given!(:user2) { create(:user, :with_project, project: project) }
    given!(:other_user1) { create(:user) }
    given!(:other_user2) { create(:user) }
    given!(:partner1) { create(:partner, :with_project, project: project, company_name: "cuon", id: 99) }
    given!(:partner2) { create(:partner, :with_project, project: project, company_name: "cuon", id: 100) }
    given!(:other_partner1) { create(:partner) }
    given!(:other_partner2) { create(:partner) }
    given!(:file_group1) { create(:project_file_group, project: project) }
    given!(:file_group2) { create(:project_file_group, project: project) }
    given!(:file_group3) { create(:project_file_group, project: project) }
    given!(:file1) { create(:project_file, project: project, group: file_group1, original_filename: 'sample1.jpg') }
    given!(:file2) { create(:project_file, project: project, group: file_group2, original_filename: 'sample2.jpg') }
    given!(:bill1) { create(:bill, created_at: '2016-01-01', deposit_on: '2016-01-05', project: project) }
    given!(:bill2) { create(:bill, created_at: '2016-01-02', project: project) }
    background { visit project_show_path(project) }

    subject { page }

    scenario 'show' do
      is_expected.to have_header_title 'プロジェクト情報'
    end

    describe 'Project Detail View' do
      background { click_on 'プロジェクト詳細' }

      describe 'form' do
        subject { find('.project_detail__form') }

        scenario 'should show project attributes' do
          is_expected.to     have_field 'group_id'               , disabled: true, with: project.group_id
          is_expected.to     have_field 'cd'                     , disabled: true, with: project.cd
          is_expected.to     have_field 'name'                   , disabled: true, with: project.name
          is_expected.not_to have_field 'contract_on'
          is_expected.not_to have_field 'contract_type'
          is_expected.not_to have_field 'estimated_amount'
          is_expected.not_to have_field 'is_using_ses'
          is_expected.not_to have_field 'is_regular_contract'
          is_expected.not_to have_field 'start_on'
          is_expected.not_to have_field 'end_on'
          is_expected.not_to have_field 'amount'
          is_expected.not_to have_field 'payment_type'
          is_expected.to     have_field 'orderer_company_name'   , disabled: true, with: project.orderer_company_name
          is_expected.to     have_field 'orderer_department_name', disabled: true, with: project.orderer_department_name
          is_expected.to     have_field 'orderer_personnel_names', disabled: true, with: project.orderer_personnel_names&.join(', ')
          is_expected.to     have_field 'orderer_address'        , disabled: true, with: project.orderer_address
          is_expected.to     have_field 'orderer_zip_code'       , disabled: true, with: project.orderer_zip_code
          is_expected.to     have_field 'orderer_memo'           , disabled: true, with: project.orderer_memo
          is_expected.to     have_field 'billing_company_name'   , disabled: true, with: project.billing_company_name
          is_expected.to     have_field 'billing_department_name', disabled: true, with: project.billing_department_name
          is_expected.to     have_field 'billing_personnel_names', disabled: true, with: project.billing_personnel_names&.join(', ')
          is_expected.to     have_field 'billing_address'        , disabled: true, with: project.billing_address
          is_expected.to     have_field 'billing_zip_code'       , disabled: true, with: project.billing_zip_code
          is_expected.to     have_field 'billing_memo'           , disabled: true, with: project.billing_memo
          is_expected.to     have_button '編集'
          is_expected.not_to have_button 'キャンセル'
          is_expected.not_to have_button '更新'
          is_expected.to     have_button '削除'
        end

        context 'when click edit button' do
          background { click_button '編集' }

          scenario 'should have edit project fields' do
            is_expected.to     have_field 'group_id'               , disabled: false, with: project.group_id
            is_expected.to     have_field 'cd'                     , disabled: false, with: project.cd
            is_expected.to     have_field 'name'                   , disabled: false, with: project.name
            is_expected.not_to have_field 'contract_on'
            is_expected.not_to have_field 'contract_type'
            is_expected.not_to have_field 'estimated_amount'
            is_expected.not_to have_field 'is_using_ses'
            is_expected.not_to have_field 'is_regular_contract'
            is_expected.not_to have_field 'start_on'
            is_expected.not_to have_field 'end_on'
            is_expected.not_to have_field 'amount'
            is_expected.not_to have_field 'payment_type'
            is_expected.to     have_field 'orderer_company_name'   , disabled: false, with: project.orderer_company_name
            is_expected.to     have_field 'orderer_department_name', disabled: false, with: project.orderer_department_name
            is_expected.to     have_field 'orderer_personnel_names', disabled: false, with: project.orderer_personnel_names&.join(', ')
            is_expected.to     have_field 'orderer_address'        , disabled: false, with: project.orderer_address
            is_expected.to     have_field 'orderer_zip_code'       , disabled: false, with: project.orderer_zip_code
            is_expected.to     have_field 'orderer_memo'           , disabled: false, with: project.orderer_memo
            is_expected.to     have_field 'billing_company_name'   , disabled: false, with: project.billing_company_name
            is_expected.to     have_field 'billing_department_name', disabled: false, with: project.billing_department_name
            is_expected.to     have_field 'billing_personnel_names', disabled: false, with: project.billing_personnel_names&.join(', ')
            is_expected.to     have_field 'billing_address'        , disabled: false, with: project.billing_address
            is_expected.to     have_field 'billing_zip_code'       , disabled: false, with: project.billing_zip_code
            is_expected.to     have_field 'billing_memo'           , disabled: false, with: project.billing_memo
            is_expected.not_to have_button '編集'
            is_expected.to     have_button 'キャンセル'
            is_expected.to     have_button '更新'
            is_expected.not_to have_button '削除'
          end

          scenario 'should do not update when click cancel button' do
            original_group                   =  project.group_id
            original_cd                      =  project.cd
            original_name                    =  project.name
            original_orderer_company_name    =  project.orderer_company_name
            original_orderer_department_name =  project.orderer_department_name
            original_orderer_personnel_names =  project.orderer_personnel_names&.join(', ')
            original_orderer_address         =  project.orderer_address
            original_orderer_zip_code        =  project.orderer_zip_code
            original_orderer_memo            =  project.orderer_memo
            original_billing_company_name    =  project.billing_company_name
            original_billing_department_name =  project.billing_department_name
            original_billing_personnel_names =  project.billing_personnel_names&.join(', ')
            original_billing_address         =  project.billing_address
            original_billing_zip_code        =  project.billing_zip_code
            original_billing_memo            =  project.billing_memo

            select 'Group2', from: :group_id
            fill_in :cd         , with: '0000001'
            fill_in :name       , with: 'test project'
            fill_in :orderer_company_name    , with: 'test orderer company'
            fill_in :orderer_department_name , with: 'test orderer department'
            fill_in :orderer_personnel_names , with: 'test person1, test person2'
            fill_in :orderer_address         , with: 'test orderer address'
            fill_in :orderer_zip_code        , with: '1234567'
            fill_in :orderer_memo            , with: 'test orderer memo'
            fill_in :billing_company_name    , with: 'test billing company'
            fill_in :billing_department_name , with: 'test billing department'
            fill_in :billing_personnel_names , with: 'test person3, test person4'
            fill_in :billing_address         , with: 'test billing address'
            fill_in :billing_zip_code        , with: '2345678'
            fill_in :billing_memo            , with: 'test billing memo'

            expect do
              click_button 'キャンセル'
              wait_for_ajax
            end.not_to change { project.reload && project.updated_at }

            is_expected.to     have_field 'group_id'               , disabled: true, with: original_group
            is_expected.to     have_field 'cd'                     , disabled: true, with: original_cd
            is_expected.to     have_field 'name'                   , disabled: true, with: original_name
            is_expected.to     have_field 'orderer_company_name'   , disabled: true, with: original_orderer_company_name
            is_expected.to     have_field 'orderer_department_name', disabled: true, with: original_orderer_department_name
            is_expected.to     have_field 'orderer_personnel_names', disabled: true, with: original_orderer_personnel_names
            is_expected.to     have_field 'orderer_address'        , disabled: true, with: original_orderer_address
            is_expected.to     have_field 'orderer_zip_code'       , disabled: true, with: original_orderer_zip_code
            is_expected.to     have_field 'orderer_memo'           , disabled: true, with: original_orderer_memo
            is_expected.to     have_field 'billing_company_name'   , disabled: true, with: original_billing_company_name
            is_expected.to     have_field 'billing_department_name', disabled: true, with: original_billing_department_name
            is_expected.to     have_field 'billing_personnel_names', disabled: true, with: original_billing_personnel_names
            is_expected.to     have_field 'billing_address'        , disabled: true, with: original_billing_address
            is_expected.to     have_field 'billing_zip_code'       , disabled: true, with: original_billing_zip_code
            is_expected.to     have_field 'billing_memo'           , disabled: true, with: original_billing_memo
          end

          scenario 'should update when click submit button with correct values' do
            select 'Group2', from: :group_id
            fill_in :cd        , with: '0000001'
            fill_in :name       , with: 'test project'
            fill_in :orderer_company_name    , with: 'test orderer company'
            fill_in :orderer_department_name , with: 'test orderer department'
            fill_in :orderer_personnel_names , with: 'test person1, test person2'
            fill_in :orderer_address         , with: 'test orderer address'
            fill_in :orderer_zip_code        , with: '1234567'
            fill_in :orderer_memo            , with: 'test orderer memo'
            fill_in :billing_company_name    , with: 'test billing company'
            fill_in :billing_department_name , with: 'test billing department'
            fill_in :billing_personnel_names , with: 'test person3, test person4'
            fill_in :billing_address         , with: 'test billing address'
            fill_in :billing_zip_code        , with: '2345678'
            fill_in :billing_memo            , with: 'test billing memo'

            expect do
              click_button '更新'
              wait_for_ajax
            end.to change { project.reload && project.updated_at }

            is_expected.to     have_field 'group_id'               , disabled: true, with: project_group2.id
            is_expected.to     have_field 'cd'                     , disabled: true, with: '0000001'
            is_expected.to     have_field 'name'                   , disabled: true, with: 'test project'
            is_expected.to     have_field 'orderer_company_name'   , disabled: true, with: 'test orderer company'
            is_expected.to     have_field 'orderer_department_name', disabled: true, with: 'test orderer department'
            is_expected.to     have_field 'orderer_personnel_names', disabled: true, with: 'test person1, test person2'
            is_expected.to     have_field 'orderer_address'        , disabled: true, with: 'test orderer address'
            is_expected.to     have_field 'orderer_zip_code'       , disabled: true, with: '1234567'
            is_expected.to     have_field 'orderer_memo'           , disabled: true, with: 'test orderer memo'
            is_expected.to     have_field 'billing_company_name'   , disabled: true, with: 'test billing company'
            is_expected.to     have_field 'billing_department_name', disabled: true, with: 'test billing department'
            is_expected.to     have_field 'billing_personnel_names', disabled: true, with: 'test person3, test person4'
            is_expected.to     have_field 'billing_address'        , disabled: true, with: 'test billing address'
            is_expected.to     have_field 'billing_zip_code'       , disabled: true, with: '2345678'
            is_expected.to     have_field 'billing_memo'           , disabled: true, with: 'test billing memo'
          end

          scenario 'should not update when click submit button with uncorrent values' do
            select 'Group2', from: :group_id
            fill_in :cd         , with: '  '
            fill_in :name       , with: 'test project'
            fill_in :orderer_company_name    , with: 'test orderer company'
            fill_in :orderer_department_name , with: 'test orderer department'
            fill_in :orderer_personnel_names , with: 'test person1, test person2'
            fill_in :orderer_address         , with: 'test orderer address'
            fill_in :orderer_zip_code        , with: '1234567'
            fill_in :orderer_memo            , with: 'test orderer memo'
            fill_in :billing_company_name    , with: 'test billing company'
            fill_in :billing_department_name , with: 'test billing department'
            fill_in :billing_personnel_names , with: 'test person3, test person4'
            fill_in :billing_address         , with: 'test billing address'
            fill_in :billing_zip_code        , with: '2345678'
            fill_in :billing_memo            , with: 'test billing memo'

            expect do
              click_button '更新'
              wait_for_ajax
            end.not_to change { project.reload && project.updated_at }

            is_expected.to     have_field 'group_id'               , disabled: false, with: project_group2.id
            is_expected.to     have_field 'cd'                     , disabled: false, with: '  '
            is_expected.to     have_field 'name'                   , disabled: false, with: 'test project'
            is_expected.to     have_field 'orderer_company_name'   , disabled: false, with: 'test orderer company'
            is_expected.to     have_field 'orderer_department_name', disabled: false, with: 'test orderer department'
            is_expected.to     have_field 'orderer_personnel_names', disabled: false, with: 'test person1, test person2'
            is_expected.to     have_field 'orderer_address'        , disabled: false, with: 'test orderer address'
            is_expected.to     have_field 'orderer_zip_code'       , disabled: false, with: '1234567'
            is_expected.to     have_field 'orderer_memo'           , disabled: false, with: 'test orderer memo'
            is_expected.to     have_field 'billing_company_name'   , disabled: false, with: 'test billing company'
            is_expected.to     have_field 'billing_department_name', disabled: false, with: 'test billing department'
            is_expected.to     have_field 'billing_personnel_names', disabled: false, with: 'test person3, test person4'
            is_expected.to     have_field 'billing_address'        , disabled: false, with: 'test billing address'
            is_expected.to     have_field 'billing_zip_code'       , disabled: false, with: '2345678'
            is_expected.to     have_field 'billing_memo'           , disabled: false, with: 'test billing memo'
          end
        end

        context 'when click delete button' do
          scenario 'and accept the confirm' do
            page.accept_confirm('本当に削除してよろしいですか？') do
              click_button '削除'
              wait_for_ajax
            end
            sleep 3
            expect(current_path).to eq project_list_path
            expect(page).not_to have_content project.cd
          end

          scenario 'and dismiss the confirm' do
            page.dismiss_confirm do
              click_button '削除'
            end
            expect(current_path).to eq project_show_path(project)
            expect(page).to have_field 'cd', disabled: true, with: project.cd
          end
        end
      end
    end

    describe 'Bill' do
      background { click_on '請求' }

      describe 'list' do
        subject { find('.project_bill') }

        scenario 'Show' do
          is_expected.to have_button  '請求新規作成'
          is_expected.to have_content '請求番号'
          is_expected.to have_content '請求金額'
          is_expected.to have_content '支払条件'
          is_expected.to have_content '請求日'
          is_expected.to have_content '入金日'

          is_expected.to have_content bill1.cd
          is_expected.to have_content bill1.amount
          is_expected.to have_content I18n.t("enumerize.defaults.payment_type.#{bill1.payment_type}")
          is_expected.to have_content bill1.bill_on
          is_expected.to have_content bill1.deposit_on

          is_expected.to have_content bill2.cd

          expect(all('.project_bill__list__tbl__body__row td:first-child')[0]).to have_text bill2.cd
          expect(all('.project_bill__list__tbl__body__row td:first-child')[1]).to have_text bill1.cd

          subject { find('#bill-{{bill1.id}}') }
          is_expected.to have_selector '.project_bill__list__tbl__body__row--deposited'
          subject { find('#bill-{{bill2.id}}') }
          is_expected.to have_selector '.project_bill__list__tbl__body__row'
        end

        scenario 'link to a bill show page when click row' do
          find("#bill-#{bill1.id}").click

          expect(current_path).to eq bill_show_path(bill1)
          expect(page).to have_header_title '請求情報'
        end

        scenario 'show Bill New Modal when click show modal button' do
          expect(page).not_to have_css '.bill_new__outer'
          click_on '請求新規作成'
          expect(page).to     have_css '.bill_new__outer'
        end

        context 'Bill New Modal' do
          background { click_on '請求新規作成' }
          subject { find('.bill_new') }

          scenario 'show' do
            is_expected.to have_field 'cd'
            is_expected.to have_field 'amount', with: project.amount
            is_expected.to have_field 'delivery_on'
            is_expected.to have_field 'acceptance_on'
            is_expected.to have_field 'payment_type'
            is_expected.to have_field 'bill_on'
            is_expected.to have_field 'deposit_on'
            is_expected.to have_field 'memo'
            is_expected.to have_button '登録'
            is_expected.to have_button 'キャンセル'
          end

          scenario 'click submit button with correct values' do
            skip "fail on wercker"

            fill_in :cd           , with: 'BILL-1'
            fill_in :amount       , with: 222_222
            fill_in :delivery_on  , with: '2016-01-01'
            fill_in :acceptance_on, with: '2016-01-02'
            select '15日締め翌月末払い', from: :payment_type
            fill_in :bill_on      , with: '2016-01-04'
            fill_in :deposit_on   , with: '2016-01-05'
            fill_in :memo         , with: 'memo'

            expect do
              click_button '登録'
              wait_for_ajax
            end.to change(Bill, :count).by(1)

            is_expected.to have_field  'cd'            , with: ''
            is_expected.to have_field  'amount'        , with: project.amount
            is_expected.to have_field  'delivery_on'   , with: ''
            is_expected.to have_field  'acceptance_on' , with: ''
            is_expected.to have_field  'payment_type'  , with: ''
            is_expected.to have_field  'bill_on'       , with: ''
            is_expected.to have_field  'deposit_on'    , with: ''
            is_expected.to have_field  'memo'          , with: ''
          end

          scenario 'click submit button with uncorrect values' do
            skip "fail on wercker"

            fill_in :cd           , with: '  '
            fill_in :amount       , with: 222_222
            fill_in :delivery_on  , with: '2016-01-01'
            fill_in :acceptance_on, with: '2016-01-02'
            select '15日締め翌月末払い', from: :payment_type
            fill_in :bill_on      , with: '2016-01-04'
            fill_in :deposit_on   , with: '2016-01-05'
            fill_in :memo         , with: 'memo'

            expect do
              click_button '登録'
              wait_for_ajax
            end.not_to change(Bill, :count)

            is_expected.to have_field  'cd'            , with: '  '
            is_expected.to have_field  'amount'        , with: 222_222
            is_expected.to have_field  'delivery_on'   , with: '2016-01-01'
            is_expected.to have_field  'acceptance_on' , with: '2016-01-02'
            select '15日締め翌月末払い', from: :payment_type
            is_expected.to have_field  'bill_on'       , with: '2016-01-04'
            is_expected.to have_field  'deposit_on'    , with: '2016-01-05'
            is_expected.to have_field  'memo'          , with: 'memo'
          end

          scenario 'click submit button with uncorrect bill_on predate delivery_on' do
            skip "fail on wercker"

            fill_in :cd           , with: 'BILL-2'
            fill_in :amount       , with: 222_222
            fill_in :delivery_on  , with: '2016-01-01'
            fill_in :acceptance_on, with: '2016-01-02'
            select '15日締め翌月末払い', from: :payment_type
            fill_in :bill_on      , with: '2015-12-31'
            fill_in :deposit_on   , with: '2016-01-05'
            fill_in :memo         , with: 'memo'

            expect do
              click_button '登録'
              wait_for_ajax
            end.not_to change(Bill, :count)

            is_expected.to have_field  'cd'            , with: 'BILL-2'
            is_expected.to have_field  'amount'        , with: 222_222
            is_expected.to have_field  'delivery_on'   , with: '2016-01-01'
            is_expected.to have_field  'acceptance_on' , with: '2016-01-02'
            select '15日締め翌月末払い', from: :payment_type
            is_expected.to have_field  'bill_on'       , with: '2015-12-31'
            is_expected.to have_field  'deposit_on'    , with: '2016-01-05'
            is_expected.to have_field  'memo'          , with: 'memo'
          end

          scenario 'click submit button with uncorrect bill_on predate acceptance_on' do
            skip "fail on wercker"

            fill_in :cd           , with: ''
            fill_in :amount       , with: 222_222
            fill_in :delivery_on  , with: '2016-01-01'
            fill_in :acceptance_on, with: '2016-01-02'
            select '15日締め翌月末払い', from: :payment_type
            fill_in :bill_on      , with: '2016-01-01'
            fill_in :deposit_on   , with: '2016-01-05'
            fill_in :memo         , with: 'memo'

            expect do
              click_button '登録'
              wait_for_ajax
            end.not_to change(Bill, :count)

            is_expected.to have_field  'cd'            , with: ''
            is_expected.to have_field  'amount'        , with: 222_222
            is_expected.to have_field  'delivery_on'   , with: '2016-01-01'
            is_expected.to have_field  'acceptance_on' , with: '2016-01-02'
            select '15日締め翌月末払い', from: :payment_type
            is_expected.to have_field  'bill_on'       , with: '2016-01-01'
            is_expected.to have_field  'deposit_on'    , with: '2016-01-05'
            is_expected.to have_field  'memo'          , with: 'memo'
          end

          scenario 'click cancel' do
            is_expected.to      have_css '.bill_new__outer'
            click_button 'キャンセル'
            is_expected.not_to  have_css '.bill_new__outer'
          end
        end
      end
    end

    describe 'Member List View' do
      background { click_on 'メンバー' }

      describe 'User List' do
        subject { find('.user_member_list') }

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
            skip
            within('.user_member_list') { click_button '登録' }
            wait_for_ajax
          end.to change(Member, :count).by(1)
        end

        context 'when select users' do
          before { within("#user-#{user1.id}") { check 'selected' } }

          scenario 'should appear the delete button' do
            is_expected.to have_button '削除'
          end

          scenario 'and click delete button' do
            expect do
              click_button '削除'
              wait_for_ajax
            end.to change(Member, :count).by(-1)

            is_expected.not_to have_content user1.name
            is_expected.to     have_content user2.name
          end
        end
      end

      describe 'Partner List' do
        subject { find('.partner_member_list') }

        describe 'Partner Member' do
          scenario 'should show partner attributes' do
            is_expected.to have_content '名前'
            is_expected.to have_content 'メールアドレス'
            is_expected.to have_content '会社名'
            is_expected.to have_content '単価'
            is_expected.to have_content '稼働時間'
            is_expected.to have_content '下限'
            is_expected.to have_content '上限'

            is_expected.to have_field 'name'              , disabled: true, with: partner1.name
            is_expected.to have_field 'email'             , disabled: true, with: partner1.email
            is_expected.to have_field 'company_name'      , disabled: true, with: partner1.company_name
            is_expected.to have_field 'unit_price'        , disabled: true, with: partner1.members[0].unit_price
            is_expected.to have_field 'working_rate'      , disabled: true, with: partner1.members[0].working_rate
            is_expected.to have_field 'min_limit_time'    , disabled: true, with: partner1.members[0].min_limit_time
            is_expected.to have_field 'max_limit_time'    , disabled: true, with: partner1.members[0].max_limit_time
            is_expected.to have_field 'name'              , disabled: true, with: partner2.name
            is_expected.to have_field 'email'             , disabled: true, with: partner2.email
            is_expected.to have_field 'company_name'      , disabled: true, with: partner2.company_name
            is_expected.to have_field 'unit_price'        , disabled: true, with: partner2.members[0].unit_price
            is_expected.to have_field 'working_rate'      , disabled: true, with: partner2.members[0].working_rate
            is_expected.to have_field 'min_limit_time'    , disabled: true, with: partner2.members[0].min_limit_time
            is_expected.to have_field 'max_limit_time'    , disabled: true, with: partner2.members[0].max_limit_time

            is_expected.not_to have_field 'name'          , with: other_partner1.name
            is_expected.not_to have_field 'email'         , with: other_partner1.email
            is_expected.not_to have_field 'company_name'  , with: other_partner1.company_name
            is_expected.not_to have_field 'name'          , with: other_partner2.name
            is_expected.not_to have_field 'email'         , with: other_partner2.email
            is_expected.not_to have_field 'company_name'  , with: other_partner2.company_name

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
            background { click_button '編集' }

            scenario 'should have edit partner fields' do
              skip
              is_expected.to     have_field 'name'              , disabled: false, with: partner1.name
              is_expected.to     have_field 'email'             , disabled: false, with: partner1.email
              is_expected.to     have_field 'company_name'      , disabled: false, with: partner1.company_name
              is_expected.to     have_field 'unit_price'        , disabled: false, with: partner1.members[0].unit_price
              is_expected.to     have_field 'working_rate'      , disabled: false, with: partner1.members[0].working_rate
              is_expected.to     have_field 'min_limit_time'    , disabled: false, with: partner1.members[0].min_limit_time
              is_expected.to     have_field 'max_limit_time'    , disabled: false, with: partner1.members[0].max_limit_time
              is_expected.to     have_field 'name'              , disabled: false, with: partner2.name
              is_expected.to     have_field 'email'             , disabled: false, with: partner2.email
              is_expected.to     have_field 'company_name'      , disabled: false, with: partner2.company_name
              is_expected.to     have_field 'unit_price'        , disabled: false, with: partner2.members[0].unit_price
              is_expected.to     have_field 'working_rate'      , disabled: false, with: partner2.members[0].working_rate
              is_expected.to     have_field 'min_limit_time'    , disabled: false, with: partner2.members[0].min_limit_time
              is_expected.to     have_field 'max_limit_time'    , disabled: false, with: partner2.members[0].max_limit_time
              is_expected.to     have_button '登録'
              is_expected.not_to have_button 'パートナーを新規登録'
              is_expected.not_to have_button '編集'
              is_expected.to     have_button 'キャンセル'
              is_expected.to     have_button '更新'
              is_expected.not_to have_button '削除'
            end

            scenario 'should not update when click cancel button' do
              partner_1_original_name           = partner1.name
              partner_1_original_email          = partner1.email
              partner_1_original_company_name   = partner1.company_name
              partner_1_original_unit_price     = partner1.members[0].unit_price
              partner_1_original_working_rate   = partner1.members[0].working_rate
              partner_1_original_min_limit_time = partner1.members[0].min_limit_time
              partner_1_original_max_limit_time = partner1.members[0].max_limit_time
              partner_2_original_name           = partner2.name
              partner_2_original_email          = partner2.email
              partner_2_original_company_name   = partner2.company_name
              partner_2_original_unit_price     = partner2.members[0].unit_price
              partner_2_original_working_rate   = partner2.members[0].working_rate
              partner_2_original_min_limit_time = partner2.members[0].min_limit_time
              partner_2_original_max_limit_time = partner2.members[0].max_limit_time

              within("#partner-#{partner1.id}") do
                fill_in :name           , with: 'test1 name'
                fill_in :email          , with: 'test1@example.com'
                fill_in :company_name   , with: 'test1 company'
                fill_in :unit_price     , with: '1'
                fill_in :working_rate   , with: '2'
                fill_in :min_limit_time , with: '3'
                fill_in :max_limit_time , with: '4'
              end

              within("#partner-#{partner2.id}") do
                fill_in :name           , with: 'test2 name'
                fill_in :email          , with: 'test2@example.com'
                fill_in :company_name   , with: 'test2 company'
                fill_in :unit_price     , with: '5'
                fill_in :working_rate   , with: '6'
                fill_in :min_limit_time , with: '7'
                fill_in :max_limit_time , with: '8'
              end

              expect do
                click_button 'キャンセル'
                wait_for_ajax
              end.not_to change { partner1.reload && partner2.reload && partner1.updated_at && partner2.updated_at }

              is_expected.to     have_field 'name'              , disabled: true, with: partner_1_original_name
              is_expected.to     have_field 'email'             , disabled: true, with: partner_1_original_email
              is_expected.to     have_field 'company_name'      , disabled: true, with: partner_1_original_company_name
              is_expected.to     have_field 'unit_price'        , disabled: true, with: partner_1_original_unit_price
              is_expected.to     have_field 'working_rate'      , disabled: true, with: partner_1_original_working_rate
              is_expected.to     have_field 'min_limit_time'    , disabled: true, with: partner_1_original_min_limit_time
              is_expected.to     have_field 'max_limit_time'    , disabled: true, with: partner_1_original_max_limit_time
              is_expected.to     have_field 'name'              , disabled: true, with: partner_2_original_name
              is_expected.to     have_field 'email'             , disabled: true, with: partner_2_original_email
              is_expected.to     have_field 'company_name'      , disabled: true, with: partner_2_original_company_name
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
                  fill_in :email          , with: 'test1@example.com'
                  fill_in :company_name   , with: 'test1 company'
                  fill_in :unit_price     , with: '1'
                  fill_in :working_rate   , with: '2'
                  fill_in :min_limit_time , with: '3'
                  fill_in :max_limit_time , with: '4'
                end

                within("#partner-#{partner2.id}") do
                  fill_in :name           , with: 'test2 name'
                  fill_in :email          , with: 'test2@example.com'
                  fill_in :company_name   , with: 'test2 company'
                  fill_in :unit_price     , with: '5'
                  fill_in :working_rate   , with: '6'
                  fill_in :min_limit_time , with: '7'
                  fill_in :max_limit_time , with: '8'
                end

                expect do
                  click_button '更新'
                  wait_for_ajax
                end.to change { partner1.reload && partner2.reload && partner1.updated_at && partner2.updated_at }

                within("#partner-#{partner1.id}") do
                  expect(page).to     have_field 'name'            , disabled: true, with: 'test1 name'
                  expect(page).to     have_field 'email'           , disabled: true, with: 'test1@example.com'
                  expect(page).to     have_field 'company_name'    , disabled: true, with: 'test1 company'
                  expect(page).to     have_field 'unit_price'      , disabled: true, with: '1'
                  expect(page).to     have_field 'working_rate'    , disabled: true, with: '2'
                  expect(page).to     have_field 'min_limit_time'  , disabled: true, with: '3'
                  expect(page).to     have_field 'max_limit_time'  , disabled: true, with: '4'
                end

                within("#partner-#{partner2.id}") do
                  expect(page).to     have_field 'name'            , disabled: true, with: 'test2 name'
                  expect(page).to     have_field 'email'           , disabled: true, with: 'test2@example.com'
                  expect(page).to     have_field 'company_name'    , disabled: true, with: 'test2 company'
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
              end
            end

            describe 'and when partner1: incorrect, partner2: correct' do
              scenario 'only one partner should update with correct values' do
                within("#partner-#{partner1.id}") do
                  fill_in :name           , with: '  '
                  fill_in :email          , with: 'test1@example.com'
                  fill_in :company_name   , with: 'test1 company'
                  fill_in :unit_price     , with: '1'
                  fill_in :working_rate   , with: '2'
                  fill_in :min_limit_time , with: '3'
                  fill_in :max_limit_time , with: '4'
                end

                within("#partner-#{partner2.id}") do
                  skip
                  fill_in :name           , with: 'test2 name'
                  fill_in :email          , with: 'test2@example.com'
                  fill_in :company_name   , with: 'test2 company'
                  fill_in :unit_price     , with: '5'
                  fill_in :working_rate   , with: '6'
                  fill_in :min_limit_time , with: '7'
                  fill_in :max_limit_time , with: '8'
                end

                expect do
                  click_button '更新'
                  wait_for_ajax
                end.not_to change { partner1.reload && partner1.updated_at }
                partner2.reload && partner2.updated_at

                within("#partner-#{partner1.id}") do
                  expect(page).to     have_field 'name'              , disabled: false, with: partner1.name
                  expect(page).to     have_field 'email'             , disabled: false, with: partner1.email
                  expect(page).to     have_field 'company_name'      , disabled: false, with: partner1.company_name
                  expect(page).to     have_field 'unit_price'        , disabled: false, with: partner1.members[0].unit_price
                  expect(page).to     have_field 'working_rate'      , disabled: false, with: partner1.members[0].working_rate
                  expect(page).to     have_field 'min_limit_time'    , disabled: false, with: partner1.members[0].min_limit_time
                  expect(page).to     have_field 'max_limit_time'    , disabled: false, with: partner1.members[0].max_limit_time
                end

                within("#partner-#{partner2.id}") do
                  expect(page).to     have_field 'name'            , disabled: true, with: 'test2 name'
                  expect(page).to     have_field 'email'           , disabled: true, with: 'test2@example.com'
                  expect(page).to     have_field 'company_name'    , disabled: true, with: 'test2 company'
                  expect(page).to     have_field 'unit_price'      , disabled: true, with: '5'
                  expect(page).to     have_field 'working_rate'    , disabled: true, with: '6'
                  expect(page).to     have_field 'min_limit_time'  , disabled: true, with: '7'
                  expect(page).to     have_field 'max_limit_time'  , disabled: true, with: '8'
                end

                is_expected.to     have_button '登録'
                is_expected.not_to have_button 'パートナーを新規登録'
                is_expected.not_to have_button '編集'
                is_expected.to     have_button 'キャンセル'
                is_expected.to     have_button '更新'
                is_expected.not_to have_button '削除'
              end

              describe 'and when partner1: correct' do
                scenario 'partner should update with correct values' do
                  within("#partner-#{partner1.id}") do
                    fill_in :name           , with: 'test1 name'
                    fill_in :email          , with: 'test1@example.com'
                    fill_in :company_name   , with: 'test1 company'
                    fill_in :unit_price     , with: '1'
                    fill_in :working_rate   , with: '2'
                    fill_in :min_limit_time , with: '3'
                    fill_in :max_limit_time , with: '4'
                  end

                  expect do
                    click_button '更新'
                    wait_for_ajax
                  end.to change { partner1.reload && partner1.updated_at }

                  within("#partner-#{partner1.id}") do
                    expect(page).to     have_field 'name'            , disabled: true, with: 'test1 name'
                    expect(page).to     have_field 'email'           , disabled: true, with: 'test1@example.com'
                    expect(page).to     have_field 'company_name'    , disabled: true, with: 'test1 company'
                    expect(page).to     have_field 'unit_price'      , disabled: true, with: '1'
                    expect(page).to     have_field 'working_rate'    , disabled: true, with: '2'
                    expect(page).to     have_field 'min_limit_time'  , disabled: true, with: '3'
                    expect(page).to     have_field 'max_limit_time'  , disabled: true, with: '4'
                  end
                end
              end
            end

            describe 'and when partner1: incorrect, partner2: incorrect' do
              scenario 'both partners should not update with uncorrect values' do
                within("#partner-#{partner1.id}") do
                  fill_in :name           , with: '  '
                  fill_in :email          , with: 'test1@example.com'
                  fill_in :company_name   , with: 'test1 company'
                  fill_in :unit_price     , with: '1'
                  fill_in :working_rate   , with: '2'
                  fill_in :min_limit_time , with: '3'
                  fill_in :max_limit_time , with: '4'
                end

                within("#partner-#{partner2.id}") do
                  skip
                  fill_in :name           , with: '  '
                  fill_in :email          , with: 'test2@example.com'
                  fill_in :company_name   , with: 'test2 company'
                  fill_in :unit_price     , with: '5'
                  fill_in :working_rate   , with: '6'
                  fill_in :min_limit_time , with: '7'
                  fill_in :max_limit_time , with: '8'
                end

                expect do
                  click_button '更新'
                  wait_for_ajax
                end.not_to change { partner1.reload && partner2.reload && partner1.updated_at && partner2.updated_at }

                within("#partner-#{partner1.id}") do
                  expect(page).to     have_field 'name'              , disabled: false, with: partner1.name
                  expect(page).to     have_field 'email'             , disabled: false, with: partner1.email
                  expect(page).to     have_field 'company_name'      , disabled: false, with: partner1.company_name
                  expect(page).to     have_field 'unit_price'        , disabled: false, with: partner1.members[0].unit_price
                  expect(page).to     have_field 'working_rate'      , disabled: false, with: partner1.members[0].working_rate
                  expect(page).to     have_field 'min_limit_time'    , disabled: false, with: partner1.members[0].min_limit_time
                  expect(page).to     have_field 'max_limit_time'    , disabled: false, with: partner1.members[0].max_limit_time
                end

                within("#partner-#{partner2.id}") do
                  expect(page).to     have_field 'name'              , disabled: false, with: partner2.name
                  expect(page).to     have_field 'email'             , disabled: false, with: partner2.email
                  expect(page).to     have_field 'company_name'      , disabled: false, with: partner2.company_name
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
                    fill_in :email          , with: 'test1@example.com'
                    fill_in :company_name   , with: 'test1 company'
                    fill_in :unit_price     , with: '1'
                    fill_in :working_rate   , with: '2'
                    fill_in :min_limit_time , with: '3'
                    fill_in :max_limit_time , with: '4'
                  end

                  within("#partner-#{partner2.id}") do
                    fill_in :name           , with: 'test2 name'
                    fill_in :email          , with: 'test2@example.com'
                    fill_in :company_name   , with: 'test2 company'
                    fill_in :unit_price     , with: '5'
                    fill_in :working_rate   , with: '6'
                    fill_in :min_limit_time , with: '7'
                    fill_in :max_limit_time , with: '8'
                  end

                  expect do
                    click_button '更新'
                    wait_for_ajax
                  end.not_to change { partner1.reload && partner1.updated_at }
                  partner2.reload && partner2.updated_at

                  within("#partner-#{partner1.id}") do
                    expect(page).to     have_field 'name'              , disabled: false, with: partner1.name
                    expect(page).to     have_field 'email'             , disabled: false, with: partner1.email
                    expect(page).to     have_field 'company_name'      , disabled: false, with: partner1.company_name
                    expect(page).to     have_field 'unit_price'        , disabled: false, with: partner1.members[0].unit_price
                    expect(page).to     have_field 'working_rate'      , disabled: false, with: partner1.members[0].working_rate
                    expect(page).to     have_field 'min_limit_time'    , disabled: false, with: partner1.members[0].min_limit_time
                    expect(page).to     have_field 'max_limit_time'    , disabled: false, with: partner1.members[0].max_limit_time
                  end

                  within("#partner-#{partner2.id}") do
                    expect(page).to     have_field 'name'            , disabled: true, with: 'test2 name'
                    expect(page).to     have_field 'email'           , disabled: true, with: 'test2@example.com'
                    expect(page).to     have_field 'company_name'    , disabled: true, with: 'test2 company'
                    expect(page).to     have_field 'unit_price'      , disabled: true, with: '5'
                    expect(page).to     have_field 'working_rate'    , disabled: true, with: '6'
                    expect(page).to     have_field 'min_limit_time'  , disabled: true, with: '7'
                    expect(page).to     have_field 'max_limit_time'  , disabled: true, with: '8'
                  end
                end

                describe 'and when partner1: correct' do
                  scenario 'partner should update with correct values' do
                    within("#partner-#{partner1.id}") do
                      fill_in :name           , with: 'test1 name'
                      fill_in :email          , with: 'test1@example.com'
                      fill_in :company_name   , with: 'test1 company'
                      fill_in :unit_price     , with: '1'
                      fill_in :working_rate   , with: '2'
                      fill_in :min_limit_time , with: '3'
                      fill_in :max_limit_time , with: '4'
                    end

                    expect do
                      click_button '更新'
                      wait_for_ajax
                    end.to change { partner1.reload && partner1.updated_at }

                    within("#partner-#{partner1.id}") do
                      expect(page).to     have_field 'name'            , disabled: true, with: 'test1 name'
                      expect(page).to     have_field 'email'           , disabled: true, with: 'test1@example.com'
                      expect(page).to     have_field 'company_name'    , disabled: true, with: 'test1 company'
                      expect(page).to     have_field 'unit_price'      , disabled: true, with: '1'
                      expect(page).to     have_field 'working_rate'    , disabled: true, with: '2'
                      expect(page).to     have_field 'min_limit_time'  , disabled: true, with: '3'
                      expect(page).to     have_field 'max_limit_time'  , disabled: true, with: '4'
                    end
                  end
                end
              end
            end
          end

          scenario 'and click delete button' do
            skip
            expect do
              click_button '削除'
              wait_for_ajax
            end.to change(Member, :count).by(-2)

            is_expected.not_to have_field 'name', disabled: false, with: partner1.name
            is_expected.not_to have_field 'name', disabled: false, with: partner2.name
          end
        end

        scenario 'select partner and click submit button with correct values' do
          select other_partner1.name, from: :partner
          fill_in :new_unit_price, with: '1'
          fill_in :new_working_rate, with: '0.6'
          fill_in :new_min_limit_time, with: '1'
          fill_in :new_max_limit_time, with: '2'

          expect do
            within('.member_list__partner') { click_button '登録' }
            wait_for_ajax
          end.to change(Member, :count).by(1)
        end

        scenario 'select partner and click submit button with uncorrect values' do
          select other_partner2.name, from: :partner
          fill_in :new_unit_price, with: '1'
          fill_in :new_working_rate, with: '0.6'
          fill_in :new_min_limit_time, with: '0.2'
          fill_in :new_max_limit_time, with: '0.1'

          expect do
            within('.member_list__partner') { click_button '登録' }
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
                within('.partner_new') { click_button '登録' }
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
                within('.partner_new') { click_button '登録' }
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

    describe 'File View' do
      background { click_on 'ファイル' }

      describe 'File New' do
        subject { find('.file_new') }

        scenario 'attach file and click upload button' do
          attach_file 'files', Rails.root.join('spec/fixtures/sample.jpg')

          expect do
            click_button 'アップロード'
            wait_for_ajax
          end.to change(ProjectFile, :count).by(1)
        end
      end

      describe 'File List' do
        subject { find('.file_list') }

        scenario 'Show' do
          is_expected.to have_content 'ファイル名'
          is_expected.to have_content 'サイズ'

          is_expected.to have_content file1.original_filename
          is_expected.to have_content file1.group.name
          is_expected.to have_content file2.original_filename
          is_expected.to have_content file2.group.name
        end

        scenario 'click create button with corrent value' do
          fill_in :name, with: 'New Group'

          expect do
            click_button '登録'
            wait_for_ajax
          end.to change(ProjectFileGroup, :count).by(1)

          is_expected.to have_field 'name', with: ''
        end

        scenario 'click create button with uncorrent value' do
          fill_in :name, with: '  '

          expect do
            click_button '登録'
            wait_for_ajax
          end.not_to change(ProjectFileGroup, :count)

          is_expected.to have_field 'name', with: '  '
        end

        context 'select files' do
          before do
            within("#file-#{file1.id}") { check 'selected' }
            within("#file-#{file2.id}") { check 'selected' }
          end

          context 'and update file group click update button' do
            before do
              first('.file_list__group_update__btn').click
              select file_group3.name
              click_on '更新'
              wait_for_ajax
            end

            scenario "update file's group" do
              is_expected.to     have_content file_group3.name
              is_expected.not_to have_content file_group1.name
              is_expected.not_to have_content file_group2.name
            end
          end

          context 'when click delete button' do
            scenario 'and accept the confirm' do
              page.accept_confirm('本当に削除してよろしいですか？') do
                click_button '削除'
                wait_for_ajax
              end
              is_expected.not_to have_content file1.original_filename
              is_expected.not_to have_content file2.original_filename
            end

            scenario 'and dismiss the confirm' do
              page.dismiss_confirm do
                click_button '削除'
              end
              is_expected.to have_content file1.original_filename
              is_expected.to have_content file2.original_filename
            end
          end
        end

        context 'when click file name' do
          before { click_on file1.original_filename, match: :first }

          scenario 'download the file' do
            expect(page.response_headers['Content-Type']).to eq('image/jpeg')
          end
        end
      end
    end
  end

  describe 'that is contracted project' do
    given!(:project_group1) { create(:project_group, name: 'Group1') }
    given!(:project) { create(:contracted_project, group: project_group1, end_on: '2016-06-10', payment_type: 'bill_on_15th_and_payment_on_end_of_next_month') }
    given(:now) { Time.zone.parse('2016-06-01') }

    around { |example| Timecop.travel(now) { example.run } }
    background { visit project_show_path(project) }

    subject { page }

    describe 'Bill New View' do
      describe 'form' do
        background { click_on '請求' }
        background { click_on '請求新規作成' }
        subject { find('.bill_new') }

        scenario 'show' do
          is_expected.to have_field 'cd'
          is_expected.to have_field 'amount'
          expect(find('#amount').value).to eq project.amount.to_s(:delimited)
          is_expected.to have_field 'delivery_on'   , with: '2016-06-10'
          is_expected.to have_field 'acceptance_on' , with: '2016-06-10'
          is_expected.to have_field 'payment_type'  , with: 'bill_on_15th_and_payment_on_end_of_next_month'
          is_expected.to have_field 'bill_on'       , with: '2016-06-15'
          is_expected.to have_field 'deposit_on'    , with: ''
          is_expected.to have_field 'memo'
          is_expected.to have_button '登録'
        end

        scenario 'click submit button with correct values' do
          fill_in :cd              , with: 'BILL-1'
          fill_in :amount          , with: project.amount
          fill_in :delivery_on     , with: '2016-01-01'
          fill_in :acceptance_on   , with: '2016-01-02'
          select  '15日締め翌月末払い', from: :payment_type
          fill_in :bill_on         , with: '2016-01-04'
          fill_in :deposit_on      , with: '2016-01-05'
          fill_in :memo            , with: 'memo'

          expect do
            click_button '登録'
            wait_for_ajax
          end.to change(Bill, :count).by(1)

          is_expected.not_to have_css '.bill_new__outer'
        end

        scenario 'click submit button with uncorrect values' do
          skip "fail on wercker"

          fill_in :cd              , with: '  '
          fill_in :amount          , with: project.amount
          fill_in :delivery_on     , with: '2016-01-01'
          fill_in :acceptance_on   , with: '2016-01-02'
          select  '15日締め翌月末払い', from: :payment_type
          fill_in :bill_on         , with: '2016-01-04'
          fill_in :deposit_on      , with: '2016-01-05'
          fill_in :memo            , with: 'memo'

          expect do
            click_button '登録'
            wait_for_ajax
          end.not_to change(Bill, :count)

          is_expected.to have_field  'cd'            , with: '  '
          is_expected.to have_field  'amount'        , with: project.amount
          is_expected.to have_field  'delivery_on'   , with: '2016-01-01'
          is_expected.to have_field  'acceptance_on' , with: '2016-01-02'
          is_expected.to have_field  'payment_type'  , with: 'bill_on_15th_and_payment_on_end_of_next_month'
          is_expected.to have_field  'bill_on'       , with: '2016-01-04'
          is_expected.to have_field  'deposit_on'    , with: '2016-01-05'
          is_expected.to have_field  'memo'          , with: 'memo'
        end
      end
    end
  end
end
