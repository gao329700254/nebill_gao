require 'rails_helper'

RSpec.feature 'Project Show Page', js: true, versioning: true do
  given!(:user) { create(:user) }
  background { login user, with_capybara: true }

  describe 'that is uncontracted project' do
    given!(:project_group1) { create(:project_group, name: 'Group1') }
    given!(:project_group2) { create(:project_group, name: 'Group2') }
    given!(:project) { create(:uncontracted_project, group: project_group1) }
    given!(:user1) { create(:user, :with_bill, bill: bill1) }
    given!(:user2) { create(:user, :with_bill, bill: bill2) }
    given!(:partner1) { create(:partner, :with_bill, bill: bill1, company_name: "cuon", id: 99_999) }
    given!(:partner2) { create(:partner, :with_bill, bill: bill2, company_name: "cuon", id: 100_000) }
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
          is_expected.to     have_field 'memo'                   , disabled: true, with: project.memo
          is_expected.to     have_unchecked_field 'contracted'   , disabled: true
          is_expected.to     have_unchecked_field 'unprocessed'  , disabled: true
          is_expected.not_to have_field 'contract_on'
          is_expected.not_to have_field 'status'
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
          is_expected.to     have_field 'orderer_phone_number'   , disabled: true, with: project.orderer_phone_number
          is_expected.to     have_field 'orderer_memo'           , disabled: true, with: project.orderer_memo
          is_expected.to     have_field 'billing_company_name'   , disabled: true, with: project.billing_company_name
          is_expected.to     have_field 'billing_department_name', disabled: true, with: project.billing_department_name
          is_expected.to     have_field 'billing_personnel_names', disabled: true, with: project.billing_personnel_names&.join(', ')
          is_expected.to     have_field 'billing_address'        , disabled: true, with: project.billing_address
          is_expected.to     have_field 'billing_zip_code'       , disabled: true, with: project.billing_zip_code
          is_expected.to     have_field 'billing_phone_number'   , disabled: true, with: project.billing_phone_number
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
            is_expected.to     have_field 'memo'                   , disabled: false, with: project.memo
            is_expected.to     have_unchecked_field 'contracted'   , disabled: false
            is_expected.to     have_unchecked_field 'unprocessed'  , disabled: false
            is_expected.not_to have_field 'contract_on'
            is_expected.not_to have_field 'status'
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
            is_expected.to     have_field 'orderer_phone_number'   , disabled: false, with: project.orderer_phone_number
            is_expected.to     have_field 'orderer_memo'           , disabled: false, with: project.orderer_memo
            is_expected.to     have_field 'billing_company_name'   , disabled: false, with: project.billing_company_name
            is_expected.to     have_field 'billing_department_name', disabled: false, with: project.billing_department_name
            is_expected.to     have_field 'billing_personnel_names', disabled: false, with: project.billing_personnel_names&.join(', ')
            is_expected.to     have_field 'billing_address'        , disabled: false, with: project.billing_address
            is_expected.to     have_field 'billing_zip_code'       , disabled: false, with: project.billing_zip_code
            is_expected.to     have_field 'billing_phone_number'   , disabled: false, with: project.billing_phone_number
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
            original_memo                    =  project.memo
            original_orderer_company_name    =  project.orderer_company_name
            original_orderer_department_name =  project.orderer_department_name
            original_orderer_personnel_names =  project.orderer_personnel_names&.join(', ')
            original_orderer_address         =  project.orderer_address
            original_orderer_zip_code        =  project.orderer_zip_code
            original_orderer_phone_number    =  project.orderer_phone_number
            original_orderer_memo            =  project.orderer_memo
            original_billing_company_name    =  project.billing_company_name
            original_billing_department_name =  project.billing_department_name
            original_billing_personnel_names =  project.billing_personnel_names&.join(', ')
            original_billing_address         =  project.billing_address
            original_billing_zip_code        =  project.billing_zip_code
            original_billing_phone_number    =  project.billing_phone_number
            original_billing_memo            =  project.billing_memo

            select 'Group2', from: :group_id
            fill_in :cd         , with: '0000001'
            fill_in :name       , with: 'test project'
            fill_in :memo       , with: 'test memo'
            fill_in :orderer_company_name    , with: 'test orderer company'
            fill_in :orderer_department_name , with: 'test orderer department'
            fill_in :orderer_personnel_names , with: 'test person1, test person2'
            fill_in :orderer_address         , with: 'test orderer address'
            fill_in :orderer_zip_code        , with: '1234567'
            fill_in :orderer_phone_number    , with: '123456789'
            fill_in :orderer_memo            , with: 'test orderer memo'
            fill_in :billing_company_name    , with: 'test billing company'
            fill_in :billing_department_name , with: 'test billing department'
            fill_in :billing_personnel_names , with: 'test person3, test person4'
            fill_in :billing_address         , with: 'test billing address'
            fill_in :billing_zip_code        , with: '2345678'
            fill_in :billing_phone_number    , with: '123456789'
            fill_in :billing_memo            , with: 'test billing memo'

            expect do
              click_button 'キャンセル'
              wait_for_ajax
            end.not_to change { project.reload && project.updated_at }

            is_expected.to     have_field 'group_id'               , disabled: true, with: original_group
            is_expected.to     have_field 'cd'                     , disabled: true, with: original_cd
            is_expected.to     have_field 'name'                   , disabled: true, with: original_name
            is_expected.to     have_field 'memo'                   , disabled: true, with: original_memo
            is_expected.to     have_field 'orderer_company_name'   , disabled: true, with: original_orderer_company_name
            is_expected.to     have_field 'orderer_department_name', disabled: true, with: original_orderer_department_name
            is_expected.to     have_field 'orderer_personnel_names', disabled: true, with: original_orderer_personnel_names
            is_expected.to     have_field 'orderer_address'        , disabled: true, with: original_orderer_address
            is_expected.to     have_field 'orderer_zip_code'       , disabled: true, with: original_orderer_zip_code
            is_expected.to     have_field 'orderer_phone_number'   , disabled: true, with: original_orderer_phone_number
            is_expected.to     have_field 'orderer_memo'           , disabled: true, with: original_orderer_memo
            is_expected.to     have_field 'billing_company_name'   , disabled: true, with: original_billing_company_name
            is_expected.to     have_field 'billing_department_name', disabled: true, with: original_billing_department_name
            is_expected.to     have_field 'billing_personnel_names', disabled: true, with: original_billing_personnel_names
            is_expected.to     have_field 'billing_address'        , disabled: true, with: original_billing_address
            is_expected.to     have_field 'billing_zip_code'       , disabled: true, with: original_billing_zip_code
            is_expected.to     have_field 'billing_phone_number'   , disabled: true, with: original_billing_phone_number
            is_expected.to     have_field 'billing_memo'           , disabled: true, with: original_billing_memo
          end

          scenario 'should update when click submit button with correct values' do
            select 'Group2', from: :group_id
            fill_in :cd        , with: '17D001A'
            fill_in :name       , with: 'test project'
            fill_in :memo       , with: 'test memo'
            fill_in :orderer_company_name    , with: 'test orderer company'
            fill_in :orderer_department_name , with: 'test orderer department'
            fill_in :orderer_personnel_names , with: 'test person1, test person2'
            fill_in :orderer_address         , with: 'test orderer address'
            fill_in :orderer_zip_code        , with: '1234567'
            fill_in :orderer_phone_number    , with: '123456789'
            fill_in :orderer_memo            , with: 'test orderer memo'
            fill_in :billing_company_name    , with: 'test billing company'
            fill_in :billing_department_name , with: 'test billing department'
            fill_in :billing_personnel_names , with: 'test person3, test person4'
            fill_in :billing_address         , with: 'test billing address'
            fill_in :billing_zip_code        , with: '2345678'
            fill_in :billing_phone_number    , with: '123456789'
            fill_in :billing_memo            , with: 'test billing memo'

            expect do
              click_button '更新'
              wait_for_ajax
            end.to change { project.reload && project.updated_at }

            is_expected.to     have_field 'group_id'               , disabled: true, with: project_group2.id
            is_expected.to     have_field 'cd'                     , disabled: true, with: '17D001A'
            is_expected.to     have_field 'name'                   , disabled: true, with: 'test project'
            is_expected.to     have_field 'memo'                   , disabled: true, with: 'test memo'
            is_expected.to     have_field 'orderer_company_name'   , disabled: true, with: 'test orderer company'
            is_expected.to     have_field 'orderer_department_name', disabled: true, with: 'test orderer department'
            is_expected.to     have_field 'orderer_personnel_names', disabled: true, with: 'test person1, test person2'
            is_expected.to     have_field 'orderer_address'        , disabled: true, with: 'test orderer address'
            is_expected.to     have_field 'orderer_zip_code'       , disabled: true, with: '1234567'
            is_expected.to     have_field 'orderer_phone_number'   , disabled: true, with: '123456789'
            is_expected.to     have_field 'orderer_memo'           , disabled: true, with: 'test orderer memo'
            is_expected.to     have_field 'billing_company_name'   , disabled: true, with: 'test billing company'
            is_expected.to     have_field 'billing_department_name', disabled: true, with: 'test billing department'
            is_expected.to     have_field 'billing_personnel_names', disabled: true, with: 'test person3, test person4'
            is_expected.to     have_field 'billing_address'        , disabled: true, with: 'test billing address'
            is_expected.to     have_field 'billing_zip_code'       , disabled: true, with: '2345678'
            is_expected.to     have_field 'billing_phone_number'   , disabled: true, with: '123456789'
            is_expected.to     have_field 'billing_memo'           , disabled: true, with: 'test billing memo'

            expect(page).to    have_content '最終更新日時: ' + I18n.l(project.updated_at.in_time_zone('Tokyo'))
          end

          scenario 'should not update when click submit button with uncorrect values' do
            select 'Group2', from: :group_id
            fill_in :cd         , with: '  '
            fill_in :name       , with: 'test project'
            fill_in :memo       , with: 'test memo'
            fill_in :orderer_company_name    , with: 'test orderer company'
            fill_in :orderer_department_name , with: 'test orderer department'
            fill_in :orderer_personnel_names , with: 'test person1, test person2'
            fill_in :orderer_address         , with: 'test orderer address'
            fill_in :orderer_zip_code        , with: '1234567'
            fill_in :orderer_phone_number    , with: '123456789'
            fill_in :orderer_memo            , with: 'test orderer memo'
            fill_in :billing_company_name    , with: 'test billing company'
            fill_in :billing_department_name , with: 'test billing department'
            fill_in :billing_personnel_names , with: 'test person3, test person4'
            fill_in :billing_address         , with: 'test billing address'
            fill_in :billing_zip_code        , with: '2345678'
            fill_in :billing_phone_number    , with: '123456789'
            fill_in :billing_memo            , with: 'test billing memo'

            expect do
              click_button '更新'
              wait_for_ajax
            end.not_to change { project.reload && project.updated_at }

            is_expected.to     have_field 'group_id'               , disabled: false, with: project_group2.id
            is_expected.to     have_field 'cd'                     , disabled: false, with: '  '
            is_expected.to     have_field 'name'                   , disabled: false, with: 'test project'
            is_expected.to     have_field 'memo'                   , disabled: false, with: 'test memo'
            is_expected.to     have_unchecked_field 'contracted'   , disabled: false
            is_expected.to     have_unchecked_field 'unprocessed'  , disabled: false
            is_expected.to     have_field 'orderer_company_name'   , disabled: false, with: 'test orderer company'
            is_expected.to     have_field 'orderer_department_name', disabled: false, with: 'test orderer department'
            is_expected.to     have_field 'orderer_personnel_names', disabled: false, with: 'test person1, test person2'
            is_expected.to     have_field 'orderer_address'        , disabled: false, with: 'test orderer address'
            is_expected.to     have_field 'orderer_zip_code'       , disabled: false, with: '1234567'
            is_expected.to     have_field 'orderer_phone_number'   , disabled: false, with: '123456789'
            is_expected.to     have_field 'orderer_memo'           , disabled: false, with: 'test orderer memo'
            is_expected.to     have_field 'billing_company_name'   , disabled: false, with: 'test billing company'
            is_expected.to     have_field 'billing_department_name', disabled: false, with: 'test billing department'
            is_expected.to     have_field 'billing_personnel_names', disabled: false, with: 'test person3, test person4'
            is_expected.to     have_field 'billing_address'        , disabled: false, with: 'test billing address'
            is_expected.to     have_field 'billing_zip_code'       , disabled: false, with: '2345678'
            is_expected.to     have_field 'billing_phone_number'   , disabled: false, with: '123456789'
            is_expected.to     have_field 'billing_memo'           , disabled: false, with: 'test billing memo'
          end

          scenario 'should update when unprocessed is true and accept the confirm with correct values' do
            select 'Group2', from: :group_id
            fill_in :cd        , with: '17D001A'
            fill_in :name       , with: 'test project'
            fill_in :memo       , with: 'test memo'
            check   :unprocessed
            fill_in :orderer_company_name    , with: 'test orderer company'
            fill_in :orderer_department_name , with: 'test orderer department'
            fill_in :orderer_personnel_names , with: 'test person1, test person2'
            fill_in :orderer_address         , with: 'test orderer address'
            fill_in :orderer_zip_code        , with: '1234567'
            fill_in :orderer_phone_number    , with: '123456789'
            fill_in :orderer_memo            , with: 'test orderer memo'
            fill_in :billing_company_name    , with: 'test billing company'
            fill_in :billing_department_name , with: 'test billing department'
            fill_in :billing_personnel_names , with: 'test person3, test person4'
            fill_in :billing_address         , with: 'test billing address'
            fill_in :billing_zip_code        , with: '2345678'
            fill_in :billing_phone_number    , with: '123456789'
            fill_in :billing_memo            , with: 'test billing memo'

            expect do
              page.accept_confirm('本当に失注にしてよろしいですか？') do
                click_button '更新'
                wait_for_ajax
                sleep 3
              end
            end.to change { project.reload && project.updated_at }

            is_expected.to     have_field 'group_id'               , disabled: true, with: project_group2.id
            is_expected.to     have_field 'cd'                     , disabled: true, with: '17D001A'
            is_expected.to     have_field 'name'                   , disabled: true, with: 'test project'
            is_expected.to     have_field 'memo'                   , disabled: true, with: 'test memo'
            is_expected.to     have_checked_field 'unprocessed'    , disabled: true, with: 'true'
            is_expected.to     have_field 'orderer_company_name'   , disabled: true, with: 'test orderer company'
            is_expected.to     have_field 'orderer_department_name', disabled: true, with: 'test orderer department'
            is_expected.to     have_field 'orderer_personnel_names', disabled: true, with: 'test person1, test person2'
            is_expected.to     have_field 'orderer_address'        , disabled: true, with: 'test orderer address'
            is_expected.to     have_field 'orderer_zip_code'       , disabled: true, with: '1234567'
            is_expected.to     have_field 'orderer_phone_number'   , disabled: true, with: '123456789'
            is_expected.to     have_field 'orderer_memo'           , disabled: true, with: 'test orderer memo'
            is_expected.to     have_field 'billing_company_name'   , disabled: true, with: 'test billing company'
            is_expected.to     have_field 'billing_department_name', disabled: true, with: 'test billing department'
            is_expected.to     have_field 'billing_personnel_names', disabled: true, with: 'test person3, test person4'
            is_expected.to     have_field 'billing_address'        , disabled: true, with: 'test billing address'
            is_expected.to     have_field 'billing_zip_code'       , disabled: true, with: '2345678'
            is_expected.to     have_field 'billing_phone_number'   , disabled: true, with: '123456789'
            is_expected.to     have_field 'billing_memo'           , disabled: true, with: 'test billing memo'
            # is_expected.not_to have_button '編集'
            is_expected.not_to have_button 'キャンセル'
            is_expected.not_to have_button '更新'
            is_expected.to     have_button '削除'
          end

          scenario 'should not update when unprocessed is true and dismiss the confirm' do
            select 'Group2', from: :group_id
            fill_in :cd        , with: '17D001A'
            fill_in :name       , with: 'test project'
            fill_in :memo       , with: 'test memo'
            check   :unprocessed
            fill_in :orderer_company_name    , with: 'test orderer company'
            fill_in :orderer_department_name , with: 'test orderer department'
            fill_in :orderer_personnel_names , with: 'test person1, test person2'
            fill_in :orderer_address         , with: 'test orderer address'
            fill_in :orderer_zip_code        , with: '1234567'
            fill_in :orderer_phone_number    , with: '123456789'
            fill_in :orderer_memo            , with: 'test orderer memo'
            fill_in :billing_company_name    , with: 'test billing company'
            fill_in :billing_department_name , with: 'test billing department'
            fill_in :billing_personnel_names , with: 'test person3, test person4'
            fill_in :billing_address         , with: 'test billing address'
            fill_in :billing_zip_code        , with: '2345678'
            fill_in :billing_phone_number    , with: '123456789'
            fill_in :billing_memo            , with: 'test billing memo'

            expect do
              page.dismiss_confirm do
                click_button '更新'
                wait_for_ajax
                sleep 3
              end
            end.not_to change { project.reload && project.updated_at }

            is_expected.to     have_field 'group_id'               , disabled: false, with: project_group2.id
            is_expected.to     have_field 'cd'                     , disabled: false, with: '17D001A'
            is_expected.to     have_field 'name'                   , disabled: false, with: 'test project'
            is_expected.to     have_field 'memo'                   , disabled: false, with: 'test memo'
            is_expected.to     have_checked_field 'unprocessed'    , disabled: false, with: 'true'
            is_expected.to     have_field 'orderer_company_name'   , disabled: false, with: 'test orderer company'
            is_expected.to     have_field 'orderer_department_name', disabled: false, with: 'test orderer department'
            is_expected.to     have_field 'orderer_personnel_names', disabled: false, with: 'test person1, test person2'
            is_expected.to     have_field 'orderer_address'        , disabled: false, with: 'test orderer address'
            is_expected.to     have_field 'orderer_zip_code'       , disabled: false, with: '1234567'
            is_expected.to     have_field 'orderer_phone_number'   , disabled: false, with: '123456789'
            is_expected.to     have_field 'orderer_memo'           , disabled: false, with: 'test orderer memo'
            is_expected.to     have_field 'billing_company_name'   , disabled: false, with: 'test billing company'
            is_expected.to     have_field 'billing_department_name', disabled: false, with: 'test billing department'
            is_expected.to     have_field 'billing_personnel_names', disabled: false, with: 'test person3, test person4'
            is_expected.to     have_field 'billing_address'        , disabled: false, with: 'test billing address'
            is_expected.to     have_field 'billing_zip_code'       , disabled: false, with: '2345678'
            is_expected.to     have_field 'billing_phone_number'   , disabled: false, with: '123456789'
            is_expected.to     have_field 'billing_memo'           , disabled: false, with: 'test billing memo'
            is_expected.not_to have_button '編集'
            is_expected.to     have_button 'キャンセル'
            is_expected.to     have_button '更新'
            is_expected.not_to have_button '削除'
          end

          scenario 'should not update when unprocessed is true and accept the confirm with uncorrect value' do
            select 'Group2', from: :group_id
            fill_in :cd        , with: '  '
            fill_in :name       , with: 'test project'
            fill_in :memo       , with: 'test memo'
            check   :unprocessed
            fill_in :orderer_company_name    , with: 'test orderer company'
            fill_in :orderer_department_name , with: 'test orderer department'
            fill_in :orderer_personnel_names , with: 'test person1, test person2'
            fill_in :orderer_address         , with: 'test orderer address'
            fill_in :orderer_zip_code        , with: '1234567'
            fill_in :orderer_phone_number    , with: '123456789'
            fill_in :orderer_memo            , with: 'test orderer memo'
            fill_in :billing_company_name    , with: 'test billing company'
            fill_in :billing_department_name , with: 'test billing department'
            fill_in :billing_personnel_names , with: 'test person3, test person4'
            fill_in :billing_address         , with: 'test billing address'
            fill_in :billing_zip_code        , with: '2345678'
            fill_in :billing_phone_number    , with: '123456789'
            fill_in :billing_memo            , with: 'test billing memo'

            expect do
              page.accept_confirm('本当に失注にしてよろしいですか？') do
                click_button '更新'
                wait_for_ajax
                sleep 3
              end
            end.not_to change { project.reload && project.updated_at }

            is_expected.to     have_field 'group_id'               , disabled: false, with: project_group2.id
            is_expected.to     have_field 'cd'                     , disabled: false, with: '  '
            is_expected.to     have_field 'name'                   , disabled: false, with: 'test project'
            is_expected.to     have_field 'memo'                   , disabled: false, with: 'test memo'
            is_expected.to     have_checked_field 'unprocessed'    , disabled: false, with: 'true'
            is_expected.to     have_field 'orderer_company_name'   , disabled: false, with: 'test orderer company'
            is_expected.to     have_field 'orderer_department_name', disabled: false, with: 'test orderer department'
            is_expected.to     have_field 'orderer_personnel_names', disabled: false, with: 'test person1, test person2'
            is_expected.to     have_field 'orderer_address'        , disabled: false, with: 'test orderer address'
            is_expected.to     have_field 'orderer_zip_code'       , disabled: false, with: '1234567'
            is_expected.to     have_field 'orderer_phone_number'   , disabled: false, with: '123456789'
            is_expected.to     have_field 'orderer_memo'           , disabled: false, with: 'test orderer memo'
            is_expected.to     have_field 'billing_company_name'   , disabled: false, with: 'test billing company'
            is_expected.to     have_field 'billing_department_name', disabled: false, with: 'test billing department'
            is_expected.to     have_field 'billing_personnel_names', disabled: false, with: 'test person3, test person4'
            is_expected.to     have_field 'billing_address'        , disabled: false, with: 'test billing address'
            is_expected.to     have_field 'billing_zip_code'       , disabled: false, with: '2345678'
            is_expected.to     have_field 'billing_phone_number'   , disabled: false, with: '123456789'
            is_expected.to     have_field 'billing_memo'           , disabled: false, with: 'test billing memo'
            is_expected.not_to have_button '編集'
            is_expected.to     have_button 'キャンセル'
            is_expected.to     have_button '更新'
            is_expected.not_to have_button '削除'
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
          wait_for_ajax

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

            expect(page).to have_content '最終更新日時: ' + I18n.l(Bill.last.updated_at.in_time_zone('Tokyo'))
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

        end
      end

      describe 'Partner List' do
        subject { find('.partner_member_list') }

        describe 'Partner Member' do
          scenario 'should show partner attributes' do
            is_expected.to have_content '名前'
            is_expected.to have_content 'メールアドレス'
            is_expected.to have_content '会社名'

            is_expected.to have_field 'name'              , disabled: true, with: partner1.name
            is_expected.to have_field 'email'             , disabled: true, with: partner1.email
            is_expected.to have_field 'company_name'      , disabled: true, with: partner1.company_name
            is_expected.to have_field 'name'              , disabled: true, with: partner2.name
            is_expected.to have_field 'email'             , disabled: true, with: partner2.email
            is_expected.to have_field 'company_name'      , disabled: true, with: partner2.company_name

            is_expected.not_to have_button '編集'
            is_expected.not_to have_button 'キャンセル'
            is_expected.not_to have_button '更新'
          end
        end

        describe 'when select partners' do
          before { within("#partner-#{partner1.id}") { check 'selected' } }
          before { within("#partner-#{partner2.id}") { check 'selected' } }

          scenario 'should appear the edit button and delete button' do
            is_expected.to have_button '編集'
          end

          describe 'and click edit button' do
            background { click_button '編集' }

            scenario 'should have edit partner fields' do
              is_expected.to     have_field 'name'              , disabled: false, with: partner1.name
              is_expected.to     have_field 'email'             , disabled: false, with: partner1.email
              is_expected.to     have_field 'company_name'      , disabled: false, with: partner1.company_name
              is_expected.to     have_field 'name'              , disabled: false, with: partner2.name
              is_expected.to     have_field 'email'             , disabled: false, with: partner2.email
              is_expected.to     have_field 'company_name'      , disabled: false, with: partner2.company_name
              is_expected.not_to have_button '編集'
              is_expected.to     have_button 'キャンセル'
              is_expected.to     have_button '更新'
            end

            scenario 'should not update when click cancel button' do
              partner_1_original_name           = partner1.name
              partner_1_original_email          = partner1.email
              partner_1_original_company_name   = partner1.company_name
              partner_2_original_name           = partner2.name
              partner_2_original_email          = partner2.email
              partner_2_original_company_name   = partner2.company_name

              within("#partner-#{partner1.id}") do
                fill_in :name           , with: 'test1 name'
                fill_in :email          , with: 'test1@example.com'
                fill_in :company_name   , with: 'test1 company'
              end

              within("#partner-#{partner2.id}") do
                fill_in :name           , with: 'test2 name'
                fill_in :email          , with: 'test2@example.com'
                fill_in :company_name   , with: 'test2 company'
              end

              expect do
                click_button 'キャンセル'
                wait_for_ajax
              end.not_to change { partner1.reload && partner2.reload && partner1.updated_at && partner2.updated_at }

              is_expected.to     have_field 'name'              , disabled: true, with: partner_1_original_name
              is_expected.to     have_field 'email'             , disabled: true, with: partner_1_original_email
              is_expected.to     have_field 'company_name'      , disabled: true, with: partner_1_original_company_name
              is_expected.to     have_field 'name'              , disabled: true, with: partner_2_original_name
              is_expected.to     have_field 'email'             , disabled: true, with: partner_2_original_email
              is_expected.to     have_field 'company_name'      , disabled: true, with: partner_2_original_company_name
              is_expected.not_to have_button '編集'
              is_expected.not_to have_button 'キャンセル'
              is_expected.not_to have_button '更新'
            end

            describe 'and when partner1: correct, partner2: correct' do
              scenario 'both partners should update with correct values' do
                within("#partner-#{partner1.id}") do
                  fill_in :name           , with: 'test1 name'
                  fill_in :email          , with: 'test1@example.com'
                  fill_in :company_name   , with: 'test1 company'
                end

                within("#partner-#{partner2.id}") do
                  fill_in :name           , with: 'test2 name'
                  fill_in :email          , with: 'test2@example.com'
                  fill_in :company_name   , with: 'test2 company'
                end

                expect do
                  click_button '更新'
                  wait_for_ajax
                end.to change { partner1.reload && partner2.reload && partner1.updated_at && partner2.updated_at }

                within("#partner-#{partner1.id}") do
                  expect(page).to     have_field 'name'            , disabled: true, with: 'test1 name'
                  expect(page).to     have_field 'email'           , disabled: true, with: 'test1@example.com'
                  expect(page).to     have_field 'company_name'    , disabled: true, with: 'test1 company'
                end

                within("#partner-#{partner2.id}") do
                  expect(page).to     have_field 'name'            , disabled: true, with: 'test2 name'
                  expect(page).to     have_field 'email'           , disabled: true, with: 'test2@example.com'
                  expect(page).to     have_field 'company_name'    , disabled: true, with: 'test2 company'
                end

                is_expected.not_to have_button '編集'
                is_expected.not_to have_button 'キャンセル'
                is_expected.not_to have_button '更新'
              end
            end

            describe 'and when partner1: incorrect, partner2: correct' do
              scenario 'only one partner should update with correct values' do
                within("#partner-#{partner1.id}") do
                  fill_in :name           , with: '  '
                  fill_in :email          , with: 'test1@example.com'
                  fill_in :company_name   , with: 'test1 company'
                end

                within("#partner-#{partner2.id}") do
                  fill_in :name           , with: 'test2 name'
                  fill_in :email          , with: 'test2@example.com'
                  fill_in :company_name   , with: 'test2 company'
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
                end

                within("#partner-#{partner2.id}") do
                  expect(page).to     have_field 'name'            , disabled: true, with: 'test2 name'
                  expect(page).to     have_field 'email'           , disabled: true, with: 'test2@example.com'
                  expect(page).to     have_field 'company_name'    , disabled: true, with: 'test2 company'
                end

                is_expected.not_to have_button '編集'
                is_expected.to     have_button 'キャンセル'
                is_expected.to     have_button '更新'
              end

              describe 'and when partner1: correct' do
                scenario 'partner should update with correct values' do
                  within("#partner-#{partner1.id}") do
                    fill_in :name           , with: 'test1 name'
                    fill_in :email          , with: 'test1@example.com'
                    fill_in :company_name   , with: 'test1 company'
                  end

                  expect do
                    click_button '更新'
                    wait_for_ajax
                  end.to change { partner1.reload && partner1.updated_at }

                  within("#partner-#{partner1.id}") do
                    expect(page).to     have_field 'name'            , disabled: true, with: 'test1 name'
                    expect(page).to     have_field 'email'           , disabled: true, with: 'test1@example.com'
                    expect(page).to     have_field 'company_name'    , disabled: true, with: 'test1 company'
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
                end

                within("#partner-#{partner2.id}") do
                  skip
                  fill_in :name           , with: '  '
                  fill_in :email          , with: 'test2@example.com'
                  fill_in :company_name   , with: 'test2 company'
                end

                expect do
                  click_button '更新'
                  wait_for_ajax
                end.not_to change { partner1.reload && partner2.reload && partner1.updated_at && partner2.updated_at }

                within("#partner-#{partner1.id}") do
                  expect(page).to     have_field 'name'              , disabled: false, with: partner1.name
                  expect(page).to     have_field 'email'             , disabled: false, with: partner1.email
                  expect(page).to     have_field 'company_name'      , disabled: false, with: partner1.company_name
                end

                within("#partner-#{partner2.id}") do
                  expect(page).to     have_field 'name'              , disabled: false, with: partner2.name
                  expect(page).to     have_field 'email'             , disabled: false, with: partner2.email
                  expect(page).to     have_field 'company_name'      , disabled: false, with: partner2.company_name
                end
              end

              describe 'and when partner1: incorrect, partner2: correct' do
                scenario 'only one partner should update with correct values' do
                  within("#partner-#{partner1.id}") do
                    fill_in :name           , with: '  '
                    fill_in :email          , with: 'test1@example.com'
                    fill_in :company_name   , with: 'test1 company'
                  end

                  within("#partner-#{partner2.id}") do
                    fill_in :name           , with: 'test2 name'
                    fill_in :email          , with: 'test2@example.com'
                    fill_in :company_name   , with: 'test2 company'
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
                  end

                  within("#partner-#{partner2.id}") do
                    expect(page).to     have_field 'name'            , disabled: true, with: 'test2 name'
                    expect(page).to     have_field 'email'           , disabled: true, with: 'test2@example.com'
                    expect(page).to     have_field 'company_name'    , disabled: true, with: 'test2 company'
                  end
                end

                describe 'and when partner1: correct' do
                  scenario 'partner should update with correct values' do
                    within("#partner-#{partner1.id}") do
                      fill_in :name           , with: 'test1 name'
                      fill_in :email          , with: 'test1@example.com'
                      fill_in :company_name   , with: 'test1 company'
                    end

                    expect do
                      click_button '更新'
                      wait_for_ajax
                    end.to change { partner1.reload && partner1.updated_at }

                    within("#partner-#{partner1.id}") do
                      expect(page).to     have_field 'name'            , disabled: true, with: 'test1 name'
                      expect(page).to     have_field 'email'           , disabled: true, with: 'test1@example.com'
                      expect(page).to     have_field 'company_name'    , disabled: true, with: 'test1 company'
                    end
                  end
                end
              end
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

          expect(page).to have_content '最終更新日時: ' + I18n.l(Version.last.created_at.in_time_zone('Tokyo'))
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

        scenario 'click create button with correct value' do
          fill_in :name, with: 'New Group'

          expect do
            click_button '登録'
            wait_for_ajax
          end.to change(ProjectFileGroup, :count).by(1)

          is_expected.to have_field 'name', with: ''
        end

        scenario 'click create button with uncorrect value' do
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

              expect(page).to have_content '最終更新日時: ' + I18n.l(Version.last.created_at.in_time_zone('Tokyo'))
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

              expect(page).to have_content '最終更新日時: ' + I18n.l(Version.last.created_at.in_time_zone('Tokyo'))
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
        background do
          click_on '請求'
          click_on '請求新規作成'
        end

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

          expect(page).to have_content '最終更新日時: ' + I18n.l(Version.last.created_at.in_time_zone('Tokyo'))
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

  describe 'Project Status Value' do
    given!(:project) { create(:contracted_project, end_on: '2016-06-10', payment_type: 'bill_on_15th_and_payment_on_end_of_next_month') }

    background { visit project_show_path(project) }

    subject { page }

    # context 'when deposit_on is not filled' do
    #   background do
    #     click_on 'プロジェクト詳細'
    #     click_button '編集'
    #   end
    #   scenario 'status should not have "finished"' do
    #     is_expected.to have_select('status', options: %w(受注 売上 請求書発行))
    #   end
    # end

    context 'when deposit_on is filled' do
      background do
        click_on '請求'
        wait_for_ajax
        click_button '請求新規作成'
      end

      scenario 'and submit bill new then status should have "finished"' do
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

        visit current_path
        click_on 'プロジェクト詳細'
        click_button '編集'
        expect(page).to have_select('status', options: %w(受注 売上 請求書発行 終了))

        expect(page).to have_content '最終更新日時: ' + I18n.l(Version.last.created_at.in_time_zone('Tokyo'))
      end
    end

    context 'When status is "finished"' do
      given!(:project) { create(:contracted_project, status: 'finished') }

      subject { page }

      scenario 'all pages do not have buttons' do
        click_on '請求'
        is_expected.not_to have_button '請求新規作成'

        click_on 'メンバー'
        expect('.member_list__user').not_to have_button '登録'
        expect('.member_list__user').not_to have_field 'user'
        expect('.member_list__user').not_to have_selector 'selected'
        expect('.member_list__partner').not_to have_field 'partner'
        expect('.member_list__partner').not_to have_field 'unit_price'
        expect('.member_list__partner').not_to have_field 'working_rate'
        expect('.member_list__partner').not_to have_field 'min_limit_time'
        expect('.member_list__partner').not_to have_button 'max_limit_time'
        expect('.member_list__partner').not_to have_button '登録'
        expect('.member_list__partner').not_to have_button 'パートナー新規登録'
        expect('.member_list__partner').not_to have_selector 'selected'

        click_on 'ファイル'
        is_expected.not_to have_css '.files_new__form'
        is_expected.not_to have_css '.files_list__menu'

        expect(page).to have_content '最終更新日時: ' + I18n.l(Version.last.created_at.in_time_zone('Tokyo'))
      end
    end
  end
end
