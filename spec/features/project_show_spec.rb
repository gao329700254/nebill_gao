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
    given!(:partner1) { create(:partner, :with_project, project: project) }
    given!(:partner2) { create(:partner, :with_project, project: project) }
    given!(:other_partner1) { create(:partner) }
    given!(:other_partner2) { create(:partner) }
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
          is_expected.to     have_field 'key'                    , disabled: true, with: project.key
          is_expected.to     have_field 'name'                   , disabled: true, with: project.name
          is_expected.to     have_field 'contract_on'            , disabled: true, with: project.contract_on
          is_expected.not_to have_field 'contract_type'
          is_expected.not_to have_field 'is_using_ses'
          is_expected.not_to have_field 'contractual_coverage'
          is_expected.not_to have_field 'start_on'
          is_expected.not_to have_field 'end_on'
          is_expected.not_to have_field 'amount'
          is_expected.not_to have_field 'payment_type'
          is_expected.to     have_field 'orderer_company_name'   , disabled: true, with: project.orderer_company_name
          is_expected.to     have_field 'orderer_department_name', disabled: true, with: project.orderer_department_name
          is_expected.to     have_field 'orderer_personnel_names', disabled: true, with: project.orderer_personnel_names.join(', ')
          is_expected.to     have_field 'orderer_address'        , disabled: true, with: project.orderer_address
          is_expected.to     have_field 'orderer_zip_code'       , disabled: true, with: project.orderer_zip_code
          is_expected.to     have_field 'orderer_memo'           , disabled: true, with: project.orderer_memo
          is_expected.to     have_field 'billing_company_name'   , disabled: true, with: project.billing_company_name
          is_expected.to     have_field 'billing_department_name', disabled: true, with: project.billing_department_name
          is_expected.to     have_field 'billing_personnel_names', disabled: true, with: project.billing_personnel_names.join(', ')
          is_expected.to     have_field 'billing_address'        , disabled: true, with: project.billing_address
          is_expected.to     have_field 'billing_zip_code'       , disabled: true, with: project.billing_zip_code
          is_expected.to     have_field 'billing_memo'           , disabled: true, with: project.billing_memo
          is_expected.to     have_button '編集'
          is_expected.not_to have_button 'キャンセル'
          is_expected.not_to have_button '更新'
        end

        context 'when click edit button' do
          background { click_button '編集' }

          scenario 'should have edit project fields' do
            is_expected.to     have_field 'group_id'               , disabled: false, with: project.group_id
            is_expected.to     have_field 'key'                    , disabled: false, with: project.key
            is_expected.to     have_field 'name'                   , disabled: false, with: project.name
            is_expected.to     have_field 'contract_on'            , disabled: false, with: project.contract_on
            is_expected.not_to have_field 'contract_type'
            is_expected.not_to have_field 'is_using_ses'
            is_expected.not_to have_field 'contractual_coverage'
            is_expected.not_to have_field 'start_on'
            is_expected.not_to have_field 'end_on'
            is_expected.not_to have_field 'amount'
            is_expected.not_to have_field 'payment_type'
            is_expected.to     have_field 'orderer_company_name'   , disabled: false, with: project.orderer_company_name
            is_expected.to     have_field 'orderer_department_name', disabled: false, with: project.orderer_department_name
            is_expected.to     have_field 'orderer_personnel_names', disabled: false, with: project.orderer_personnel_names.join(', ')
            is_expected.to     have_field 'orderer_address'        , disabled: false, with: project.orderer_address
            is_expected.to     have_field 'orderer_zip_code'       , disabled: false, with: project.orderer_zip_code
            is_expected.to     have_field 'orderer_memo'           , disabled: false, with: project.orderer_memo
            is_expected.to     have_field 'billing_company_name'   , disabled: false, with: project.billing_company_name
            is_expected.to     have_field 'billing_department_name', disabled: false, with: project.billing_department_name
            is_expected.to     have_field 'billing_personnel_names', disabled: false, with: project.billing_personnel_names.join(', ')
            is_expected.to     have_field 'billing_address'        , disabled: false, with: project.billing_address
            is_expected.to     have_field 'billing_zip_code'       , disabled: false, with: project.billing_zip_code
            is_expected.to     have_field 'billing_memo'           , disabled: false, with: project.billing_memo
            is_expected.not_to have_button '編集'
            is_expected.to     have_button 'キャンセル'
            is_expected.to     have_button '更新'
          end

          scenario 'should do not update when click cancel button' do
            original_group                   =  project.group_id
            original_key                     =  project.key
            original_name                    =  project.name
            original_contract_on             =  project.contract_on
            original_orderer_company_name    =  project.orderer_company_name
            original_orderer_department_name =  project.orderer_department_name
            original_orderer_personnel_names =  project.orderer_personnel_names.join(', ')
            original_orderer_address         =  project.orderer_address
            original_orderer_zip_code        =  project.orderer_zip_code
            original_orderer_memo            =  project.orderer_memo
            original_billing_company_name    =  project.billing_company_name
            original_billing_department_name =  project.billing_department_name
            original_billing_personnel_names =  project.billing_personnel_names.join(', ')
            original_billing_address         =  project.billing_address
            original_billing_zip_code        =  project.billing_zip_code
            original_billing_memo            =  project.billing_memo

            select 'Group2', from: :group_id
            fill_in :key        , with: '0000001'
            fill_in :name       , with: 'test project'
            fill_in :contract_on, with: '2016-01-01'
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
            is_expected.to     have_field 'key'                    , disabled: true, with: original_key
            is_expected.to     have_field 'name'                   , disabled: true, with: original_name
            is_expected.to     have_field 'contract_on'            , disabled: true, with: original_contract_on
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
            fill_in :key        , with: '0000001'
            fill_in :name       , with: 'test project'
            fill_in :contract_on, with: '2016-01-01'
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
            is_expected.to     have_field 'key'                    , disabled: true, with: '0000001'
            is_expected.to     have_field 'name'                   , disabled: true, with: 'test project'
            is_expected.to     have_field 'contract_on'            , disabled: true, with: '2016-01-01'
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
            fill_in :key        , with: '  '
            fill_in :name       , with: 'test project'
            fill_in :contract_on, with: '2016-01-01'
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
            is_expected.to     have_field 'key'                    , disabled: false, with: '  '
            is_expected.to     have_field 'name'                   , disabled: false, with: 'test project'
            is_expected.to     have_field 'contract_on'            , disabled: false, with: '2016-01-01'
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
      end
    end

    describe 'Bill New View' do
      background { click_on '請求新規作成' }

      describe 'form' do
        subject { find('.bill_new__form') }

        scenario 'show' do
          is_expected.to have_field 'key'
          is_expected.to have_field 'amount', with: project.amount
          is_expected.to have_field 'delivery_on'
          is_expected.to have_field 'acceptance_on'
          is_expected.to have_field 'payment_on'
          is_expected.to have_field 'bill_on'
          is_expected.to have_field 'deposit_on'
          is_expected.to have_field 'memo'
          is_expected.to have_button '登録'
        end

        scenario 'click submit button with correct values' do
          skip "fail on wercker"

          fill_in :key, with: 'BILL-1'
          fill_in :amount       , with: 222_222
          fill_in :delivery_on  , with: '2016-01-01'
          fill_in :acceptance_on, with: '2016-01-02'
          fill_in :payment_on   , with: '2016-01-03'
          fill_in :bill_on      , with: '2016-01-04'
          fill_in :deposit_on   , with: '2016-01-05'
          fill_in :memo         , with: 'memo'

          expect do
            click_button '登録'
            wait_for_ajax
          end.to change(Bill, :count).by(1)

          is_expected.to have_field  'key'           , with: ''
          is_expected.to have_field  'amount'        , with: project.amount
          is_expected.to have_field  'delivery_on'   , with: ''
          is_expected.to have_field  'acceptance_on' , with: ''
          is_expected.to have_field  'payment_on'    , with: ''
          is_expected.to have_field  'bill_on'       , with: ''
          is_expected.to have_field  'deposit_on'    , with: ''
          is_expected.to have_field  'memo'          , with: ''
        end

        scenario 'click submit button with uncorrect values' do
          skip "fail on wercker"

          fill_in :key, with: '  '
          fill_in :amount       , with: 222_222
          fill_in :delivery_on  , with: '2016-01-01'
          fill_in :acceptance_on, with: '2016-01-02'
          fill_in :payment_on   , with: '2016-01-03'
          fill_in :bill_on      , with: '2016-01-04'
          fill_in :deposit_on   , with: '2016-01-05'
          fill_in :memo         , with: 'memo'

          expect do
            click_button '登録'
            wait_for_ajax
          end.not_to change(Bill, :count)

          is_expected.to have_field  'key'           , with: '  '
          is_expected.to have_field  'amount'        , with: 222_222
          is_expected.to have_field  'delivery_on'   , with: '2016-01-01'
          is_expected.to have_field  'acceptance_on' , with: '2016-01-02'
          is_expected.to have_field  'payment_on'    , with: '2016-01-03'
          is_expected.to have_field  'bill_on'       , with: '2016-01-04'
          is_expected.to have_field  'deposit_on'    , with: '2016-01-05'
          is_expected.to have_field  'memo'          , with: 'memo'
        end

        scenario 'click submit button with uncorrect bill_on predate delivery_on' do
          skip "fail on wercker"

          fill_in :key, with: 'BILL-2'
          fill_in :amount       , with: 222_222
          fill_in :delivery_on  , with: '2016-01-01'
          fill_in :acceptance_on, with: '2016-01-02'
          fill_in :payment_on   , with: '2016-01-03'
          fill_in :bill_on      , with: '2015-12-31'
          fill_in :deposit_on   , with: '2016-01-05'
          fill_in :memo         , with: 'memo'

          expect do
            click_button '登録'
            wait_for_ajax
          end.not_to change(Bill, :count)

          is_expected.to have_field  'key'           , with: 'BILL-2'
          is_expected.to have_field  'amount'        , with: 222_222
          is_expected.to have_field  'delivery_on'   , with: '2016-01-01'
          is_expected.to have_field  'acceptance_on' , with: '2016-01-02'
          is_expected.to have_field  'payment_on'    , with: '2016-01-03'
          is_expected.to have_field  'bill_on'       , with: '2015-12-31'
          is_expected.to have_field  'deposit_on'    , with: '2016-01-05'
          is_expected.to have_field  'memo'          , with: 'memo'
        end

        scenario 'click submit button with uncorrect bill_on predate acceptance_on' do
          skip "fail on wercker"

          fill_in :key, with: 'BILL-2'
          fill_in :amount       , with: 222_222
          fill_in :delivery_on  , with: '2016-01-01'
          fill_in :acceptance_on, with: '2016-01-02'
          fill_in :payment_on   , with: '2016-01-03'
          fill_in :bill_on      , with: '2016-01-01'
          fill_in :deposit_on   , with: '2016-01-05'
          fill_in :memo         , with: 'memo'

          expect do
            click_button '登録'
            wait_for_ajax
          end.not_to change(Bill, :count)

          is_expected.to have_field  'key'           , with: 'BILL-2'
          is_expected.to have_field  'amount'        , with: 222_222
          is_expected.to have_field  'delivery_on'   , with: '2016-01-01'
          is_expected.to have_field  'acceptance_on' , with: '2016-01-02'
          is_expected.to have_field  'payment_on'    , with: '2016-01-03'
          is_expected.to have_field  'bill_on'       , with: '2016-01-01'
          is_expected.to have_field  'deposit_on'    , with: '2016-01-05'
          is_expected.to have_field  'memo'          , with: 'memo'
        end
      end
    end

    describe 'Member List View' do
      background { click_on 'メンバー' }

      describe 'User List' do
        subject { find('.member_list__user') }

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
        end

        scenario 'select user and click submit button' do
          select other_user1.name, from: :user

          expect do
            within('.member_list__user') { click_button '登録' }
            wait_for_ajax
          end.to change(Member, :count).by(1)
        end
      end

      describe 'Partner List' do
        subject { find('.member_list__partner') }

        scenario 'Show' do
          is_expected.to have_content '名前'
          is_expected.to have_content 'メールアドレス'
          is_expected.to have_content '会社名'

          is_expected.to have_content partner1.name
          is_expected.to have_content partner1.email
          is_expected.to have_content partner1.company_name
          is_expected.to have_content partner2.name
          is_expected.to have_content partner2.email
          is_expected.to have_content partner2.company_name

          is_expected.not_to have_content other_partner1.name
          is_expected.not_to have_content other_partner1.email
          is_expected.not_to have_content other_partner1.company_name
          is_expected.not_to have_content other_partner2.name
          is_expected.not_to have_content other_partner2.email
          is_expected.not_to have_content other_partner2.company_name

          is_expected.to have_field 'partner', with: ''
          is_expected.to have_button '登録'
          is_expected.to have_button 'パートナーを新規登録する'
        end

        scenario 'select partner and click submit button' do
          select other_partner1.name, from: :partner

          expect do
            within('.member_list__partner') { click_button '登録' }
            wait_for_ajax
          end.to change(Member, :count).by(1)
        end

        scenario 'show Partner New Modal when click show modal button' do
          is_expected.not_to have_css '.partner_new__outer'
          click_on 'パートナーを新規登録する'
          is_expected.to     have_css '.partner_new__outer'
        end

        describe 'Partner New Modal' do
          before { click_on 'パートナーを新規登録する' }
          subject { find('.partner_new') }

          scenario 'show' do
            is_expected.to have_content 'パートナーを新規登録する'
          end

          describe 'form' do
            scenario 'show' do
              is_expected.to have_field 'email'
              is_expected.to have_field 'name'
              is_expected.to have_field 'company_name'
              is_expected.to have_button 'キャンセル'
              is_expected.to have_button '登録'
            end

            scenario 'click submit button with correct values' do
              fill_in :email       , with: 'foobar@example.com'
              fill_in :name        , with: 'foo bar'
              fill_in :company_name, with: 'abc'

              expect do
                within('.partner_new') { click_button '登録' }
                wait_for_ajax
              end.to change(Partner, :count).by(1)

              is_expected.not_to have_css '.partner_new__outer'
            end

            scenario 'click submit button with uncorrect values' do
              fill_in :email       , with: 'foobar@'
              fill_in :name        , with: 'foo bar'
              fill_in :company_name, with: 'abc'

              expect do
                within('.partner_new') { click_button '登録' }
                wait_for_ajax
              end.not_to change(Partner, :count)

              is_expected.to have_css '.partner_new__outer'
              is_expected.to have_field 'email'       , with: 'foobar@'
              is_expected.to have_field 'name'        , with: 'foo bar'
              is_expected.to have_field 'company_name', with: 'abc'
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

  describe 'that is contracted project' do
    given!(:project_group1) { create(:project_group, name: 'Group1') }
    given!(:project) { create(:contracted_project, group: project_group1) }
    background { visit project_show_path(project) }

    subject { page }

    describe 'Bill New View' do
      background { click_on '請求新規作成' }

      describe 'form' do
        subject { find('.bill_new__form') }

        scenario 'show' do
          is_expected.to have_field 'key'
          is_expected.to have_field 'amount'
          expect(find('#amount').value).to eq project.amount.to_s
          is_expected.to have_field 'delivery_on'
          is_expected.to have_field 'acceptance_on'
          is_expected.to have_field 'payment_on'
          is_expected.to have_field 'bill_on'
          is_expected.to have_field 'deposit_on'
          is_expected.to have_field 'memo'
          is_expected.to have_button '登録'
        end

        scenario 'click submit button with correct values' do
          fill_in :key, with: 'BILL-1'
          fill_in :amount       , with: project.amount
          fill_in :delivery_on  , with: '2016-01-01'
          fill_in :acceptance_on, with: '2016-01-02'
          fill_in :payment_on   , with: '2016-01-03'
          fill_in :bill_on      , with: '2016-01-04'
          fill_in :deposit_on   , with: '2016-01-05'
          fill_in :memo         , with: 'memo'

          expect do
            click_button '登録'
            wait_for_ajax
          end.to change(Bill, :count).by(1)

          is_expected.to have_field  'key'           , with: ''
          is_expected.to have_field  'amount'        , with: project.amount
          is_expected.to have_field  'delivery_on'   , with: ''
          is_expected.to have_field  'acceptance_on' , with: ''
          is_expected.to have_field  'payment_on'    , with: ''
          is_expected.to have_field  'bill_on'       , with: ''
          is_expected.to have_field  'deposit_on'    , with: ''
          is_expected.to have_field  'memo'          , with: ''
        end

        scenario 'click submit button with uncorrect values' do
          skip "fail on wercker"

          fill_in :key, with: '  '
          fill_in :amount       , with: project.amount
          fill_in :delivery_on  , with: '2016-01-01'
          fill_in :acceptance_on, with: '2016-01-02'
          fill_in :payment_on   , with: '2016-01-03'
          fill_in :bill_on      , with: '2016-01-04'
          fill_in :deposit_on   , with: '2016-01-05'
          fill_in :memo         , with: 'memo'

          expect do
            click_button '登録'
            wait_for_ajax
          end.not_to change(Bill, :count)

          is_expected.to have_field  'key'           , with: '  '
          is_expected.to have_field  'amount'        , with: project.amount
          is_expected.to have_field  'delivery_on'   , with: '2016-01-01'
          is_expected.to have_field  'acceptance_on' , with: '2016-01-02'
          is_expected.to have_field  'payment_on'    , with: '2016-01-03'
          is_expected.to have_field  'bill_on'       , with: '2016-01-04'
          is_expected.to have_field  'deposit_on'    , with: '2016-01-05'
          is_expected.to have_field  'memo'          , with: 'memo'
        end
      end
    end
  end

  describe 'that is corrected project' do
    given!(:project) { create(:contracted_project, end_on: '2016-06-10', payment_type: 'bill_on_15th_and_payment_on_end_of_next_month') }
    given(:now) { Time.zone.parse('2016-06-01') }
    given(:path) { "/api/projects/#{project.id}/default_dates" }

    around { |example| Timecop.travel(now) { example.run } }

    background { visit project_show_path(project) }

    subject { page }

    describe 'Bill New View' do
      background do
        click_on '請求新規作成'
        wait_for_ajax
      end

      describe 'form' do
        subject { find('.bill_new__form') }

        scenario 'show' do
          is_expected.to have_field 'key'
          is_expected.to have_field 'delivery_on'   , with: '2016-06-10'
          is_expected.to have_field 'acceptance_on' , with: '2016-06-10'
          is_expected.to have_field 'payment_on'    , with: '2016-07-31'
          is_expected.to have_field 'bill_on'       , with: '2016-06-15'
          is_expected.to have_field 'deposit_on'    , with: ''
          is_expected.to have_field 'memo'
          is_expected.to have_button '登録'
        end
      end
    end
  end
end
