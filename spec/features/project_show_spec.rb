require 'rails_helper'

RSpec.feature 'Project Show Page', js: true do
  describe 'that is uncorrected project' do
    let!(:project) { create(:uncontracted_project) }
    background { visit project_show_path(project) }

    subject { page }

    scenario 'show' do
      is_expected.to have_header_title 'プロジェクト詳細'
    end

    describe 'form' do
      subject { find('#project_show .project_show__form') }

      scenario 'should show project attributes' do
        is_expected.to     have_field 'key'                    , disabled: true, with: project.key
        is_expected.to     have_field 'name'                   , disabled: true, with: project.name
        is_expected.to     have_field 'contract_on'            , disabled: true, with: project.contract_on
        is_expected.not_to have_field 'contract_type'
        is_expected.not_to have_field 'is_using_ses'
        is_expected.not_to have_field 'contractual_coverage'
        is_expected.not_to have_field 'start_on'
        is_expected.not_to have_field 'end_on'
        is_expected.not_to have_field 'amount'
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
          is_expected.to     have_field 'key'                    , disabled: false, with: project.key
          is_expected.to     have_field 'name'                   , disabled: false, with: project.name
          is_expected.to     have_field 'contract_on'            , disabled: false, with: project.contract_on
          is_expected.not_to have_field 'contract_type'
          is_expected.not_to have_field 'is_using_ses'
          is_expected.not_to have_field 'contractual_coverage'
          is_expected.not_to have_field 'start_on'
          is_expected.not_to have_field 'end_on'
          is_expected.not_to have_field 'amount'
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
end