require 'rails_helper'

RSpec.feature 'Project New Page', js: true do
  given!(:user) { create(:user) }
  given!(:client) do
    create(
      :client,
      cd: 'CLIENT-1',
      company_name: 'clientA',
      department_name: 'client department name',
      address: 'client address',
      zip_code: 'client zip code',
    )
  end
  given!(:project_group) { create(:project_group, name: 'GroupA') }

  background { login user, with_capybara: true }
  background { visit project_new_path }

  subject { page }

  scenario 'show' do
    is_expected.to have_header_title 'プロジェクト新規作成'
  end

  describe 'form' do
    subject { find('.project_new__form') }

    scenario 'click orderer fill button' do
      select 'CLIENT-1 clientA', from: :orderer_client_id
      find('.project_new__form__orderer .project_new__form__fill--btn').click
      wait_for_ajax

      is_expected.to have_field 'orderer_company_name'    , with: 'clientA'
      is_expected.to have_field 'orderer_department_name' , with: 'client department name'
      is_expected.to have_field 'orderer_address'         , with: 'client address'
      is_expected.to have_field 'orderer_zip_code'        , with: 'client zip code'
    end

    scenario 'click billing fill button' do
      select 'CLIENT-1 clientA', from: :billing_client_id
      find('.project_new__form__billing .project_new__form__fill--btn').click
      wait_for_ajax

      is_expected.to have_field 'billing_company_name'    , with: 'clientA'
      is_expected.to have_field 'billing_department_name' , with: 'client department name'
      is_expected.to have_field 'billing_address'         , with: 'client address'
      is_expected.to have_field 'billing_zip_code'        , with: 'client zip code'
    end

    scenario 'click copy button' do
      fill_in :orderer_company_name    , with: 'test orderer company'
      fill_in :orderer_department_name , with: 'test orderer department'
      fill_in :orderer_personnel_names , with: 'test person1, test person2'
      fill_in :orderer_address         , with: 'test orderer address'
      fill_in :orderer_zip_code        , with: '1234567'
      fill_in :orderer_memo            , with: 'test orderer memo'

      is_expected.to have_field 'billing_company_name'    , with: ''
      is_expected.to have_field 'billing_department_name' , with: ''
      is_expected.to have_field 'billing_personnel_names' , with: ''
      is_expected.to have_field 'billing_address'         , with: ''
      is_expected.to have_field 'billing_zip_code'        , with: ''
      is_expected.to have_field 'billing_memo'            , with: ''

      click_button '受注先から請求先に値をコピー'

      is_expected.to have_field 'billing_company_name'    , with: 'test orderer company'
      is_expected.to have_field 'billing_department_name' , with: 'test orderer department'
      is_expected.to have_field 'billing_personnel_names' , with: 'test person1, test person2'
      is_expected.to have_field 'billing_address'         , with: 'test orderer address'
      is_expected.to have_field 'billing_zip_code'        , with: '1234567'
      is_expected.to have_field 'billing_memo'            , with: ''
      is_expected.not_to have_field 'billing_memo'        , with: 'test orderer memo'
    end

    context "when 'contracted' is unchecked" do
      background { uncheck 'contracted' }

      scenario 'show' do
        is_expected.to     have_field 'group_id'
        is_expected.to     have_field 'cd'
        is_expected.to     have_field 'name'
        is_expected.not_to have_field 'contract_on'
        is_expected.not_to have_field 'contract_type'
        is_expected.not_to have_field 'estimated_amount'
        is_expected.not_to have_field 'is_using_ses'
        is_expected.not_to have_field 'is_regular_contract'
        is_expected.not_to have_field 'start_on'
        is_expected.not_to have_field 'end_on'
        is_expected.not_to have_field 'amount'
        is_expected.not_to have_field 'payment_type'
        is_expected.to     have_field 'orderer_company_name'
        is_expected.to     have_field 'orderer_department_name'
        is_expected.to     have_field 'orderer_personnel_names'
        is_expected.to     have_field 'orderer_address'
        is_expected.to     have_field 'orderer_zip_code'
        is_expected.to     have_field 'orderer_memo'
        is_expected.to     have_field 'billing_company_name'
        is_expected.to     have_field 'billing_department_name'
        is_expected.to     have_field 'billing_personnel_names'
        is_expected.to     have_field 'billing_address'
        is_expected.to     have_field 'billing_zip_code'
        is_expected.to     have_field 'billing_memo'
        is_expected.to     have_button '受注先から請求先に値をコピー'
        is_expected.to     have_button '登録'
      end

      scenario 'click submit button with correct values' do
        select 'GroupA', from: :group_id
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
          click_button '登録'
          wait_for_ajax
        end.to change(Project, :count).by(1)

        is_expected.to have_unchecked_field 'contracted'
        is_expected.to have_field 'group_id'                , with: ''
        is_expected.to have_field 'cd'                      , with: ''
        is_expected.to have_field 'name'                    , with: ''
        is_expected.to have_field 'orderer_company_name'    , with: ''
        is_expected.to have_field 'orderer_department_name' , with: ''
        is_expected.to have_field 'orderer_personnel_names' , with: ''
        is_expected.to have_field 'orderer_address'         , with: ''
        is_expected.to have_field 'orderer_zip_code'        , with: ''
        is_expected.to have_field 'orderer_memo'            , with: ''
        is_expected.to have_field 'billing_company_name'    , with: ''
        is_expected.to have_field 'billing_department_name' , with: ''
        is_expected.to have_field 'billing_personnel_names' , with: ''
        is_expected.to have_field 'billing_address'         , with: ''
        is_expected.to have_field 'billing_zip_code'        , with: ''
        is_expected.to have_field 'billing_memo'            , with: ''
      end

      scenario 'click submit button with uncorrect values' do
        select 'GroupA', from: :group_id
        fill_in :cd         , with: ' '
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
          click_button '登録'
          wait_for_ajax
        end.not_to change(Project, :count)

        is_expected.to have_unchecked_field 'contracted'
        select 'GroupA', from: :group_id
        is_expected.to have_field 'cd'                      , with: ' '
        is_expected.to have_field 'name'                    , with: 'test project'
        is_expected.to have_field 'orderer_company_name'    , with: 'test orderer company'
        is_expected.to have_field 'orderer_department_name' , with: 'test orderer department'
        is_expected.to have_field 'orderer_personnel_names' , with: 'test person1, test person2'
        is_expected.to have_field 'orderer_address'         , with: 'test orderer address'
        is_expected.to have_field 'orderer_zip_code'        , with: '1234567'
        is_expected.to have_field 'orderer_memo'            , with: 'test orderer memo'
        is_expected.to have_field 'billing_company_name'    , with: 'test billing company'
        is_expected.to have_field 'billing_department_name' , with: 'test billing department'
        is_expected.to have_field 'billing_personnel_names' , with: 'test person3, test person4'
        is_expected.to have_field 'billing_address'         , with: 'test billing address'
        is_expected.to have_field 'billing_zip_code'        , with: '2345678'
        is_expected.to have_field 'billing_memo'            , with: 'test billing memo'
      end
    end

    context "when 'contracted' is checked" do
      background { check 'contracted' }

      scenario 'show' do
        is_expected.to     have_field 'group_id'
        is_expected.to     have_field 'cd'
        is_expected.to     have_field 'name'
        is_expected.to     have_field 'contract_on'
        is_expected.to     have_field 'contract_type'
        is_expected.to     have_field 'estimated_amount'
        is_expected.to     have_field 'is_using_ses'
        is_expected.to     have_field 'is_regular_contract'
        is_expected.to     have_field 'start_on'
        is_expected.to     have_field 'end_on'
        is_expected.to     have_field 'amount'
        is_expected.to     have_field 'payment_type'
        is_expected.to     have_field 'orderer_company_name'
        is_expected.to     have_field 'orderer_department_name'
        is_expected.to     have_field 'orderer_personnel_names'
        is_expected.to     have_field 'orderer_address'
        is_expected.to     have_field 'orderer_zip_code'
        is_expected.to     have_field 'orderer_memo'
        is_expected.to     have_field 'billing_company_name'
        is_expected.to     have_field 'billing_department_name'
        is_expected.to     have_field 'billing_personnel_names'
        is_expected.to     have_field 'billing_address'
        is_expected.to     have_field 'billing_zip_code'
        is_expected.to     have_field 'billing_memo'
        is_expected.to     have_button '受注先から請求先に値をコピー'
        is_expected.to     have_button '登録'
      end

      scenario 'click submit button with correct values' do
        select 'GroupA', from: :group_id
        fill_in :name       , with: 'test project'
        fill_in :contract_on, with: '2016-01-01'
        select '委託', from: :contract_type
        fill_in :estimated_amount, with: 1_000_000
        check   :is_using_ses
        check   :is_regular_contract
        fill_in :start_on   , with: '2016-02-01'
        fill_in :end_on     , with: '2016-03-30'
        fill_in :amount     , with: 1_000_000
        select '15日締め翌月末払い', from: :payment_type
        fill_in :cd         , with: '0000001'
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
          click_button '登録'
          wait_for_ajax
        end.to change(Project, :count).by(1)

        is_expected.to have_unchecked_field 'contracted'
        is_expected.to have_field 'group_id'                , with: ''
        is_expected.to have_field 'cd'                      , with: ''
        is_expected.to have_field 'name'                    , with: ''
        is_expected.to have_field 'orderer_company_name'    , with: ''
        is_expected.to have_field 'orderer_department_name' , with: ''
        is_expected.to have_field 'orderer_personnel_names' , with: ''
        is_expected.to have_field 'orderer_address'         , with: ''
        is_expected.to have_field 'orderer_zip_code'        , with: ''
        is_expected.to have_field 'orderer_memo'            , with: ''
        is_expected.to have_field 'billing_company_name'    , with: ''
        is_expected.to have_field 'billing_department_name' , with: ''
        is_expected.to have_field 'billing_personnel_names' , with: ''
        is_expected.to have_field 'billing_address'         , with: ''
        is_expected.to have_field 'billing_zip_code'        , with: ''
        is_expected.to have_field 'billing_memo'            , with: ''
      end

      scenario 'click submit button with uncorrect values' do
        select 'GroupA', from: :group_id
        fill_in :name       , with: '  '
        fill_in :contract_on, with: '2016-01-01'
        select '委託', from: :contract_type
        fill_in :estimated_amount, with: 1_000_000
        check   :is_using_ses
        check   :is_regular_contract
        fill_in :start_on   , with: '2016-02-01'
        fill_in :end_on     , with: '2016-03-30'
        fill_in :amount     , with: 1_000_000
        select '15日締め翌月末払い', from: :payment_type
        fill_in :cd         , with: '0000001'
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
          click_button '登録'
          wait_for_ajax
        end.not_to change(Project, :count)

        is_expected.to have_checked_field 'contracted'
        select 'GroupA', from: :group_id
        is_expected.to have_field 'cd'                      , with: '0000001'
        is_expected.to have_field 'name'                    , with: '  '
        is_expected.to have_field 'contract_on'             , with: '2016-01-01'
        select '委託', from: :contract_type
        is_expected.to have_field 'estimated_amount'        , with: '1,000,000'
        check   :is_using_ses
        check   :is_regular_contract
        is_expected.to have_field 'start_on'                , with: '2016-02-01'
        is_expected.to have_field 'end_on'                  , with: '2016-03-30'
        is_expected.to have_field 'amount'                  , with: '1,000,000'
        select '15日締め翌月末払い', from: :payment_type
        is_expected.to have_field 'orderer_company_name'    , with: 'test orderer company'
        is_expected.to have_field 'orderer_department_name' , with: 'test orderer department'
        is_expected.to have_field 'orderer_personnel_names' , with: 'test person1, test person2'
        is_expected.to have_field 'orderer_address'         , with: 'test orderer address'
        is_expected.to have_field 'orderer_zip_code'        , with: '1234567'
        is_expected.to have_field 'orderer_memo'            , with: 'test orderer memo'
        is_expected.to have_field 'billing_company_name'    , with: 'test billing company'
        is_expected.to have_field 'billing_department_name' , with: 'test billing department'
        is_expected.to have_field 'billing_personnel_names' , with: 'test person3, test person4'
        is_expected.to have_field 'billing_address'         , with: 'test billing address'
        is_expected.to have_field 'billing_zip_code'        , with: '2345678'
        is_expected.to have_field 'billing_memo'            , with: 'test billing memo'
      end
    end
  end
end
