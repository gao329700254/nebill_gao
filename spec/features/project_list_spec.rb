require 'rails_helper'

RSpec.feature 'Project List Page', js: true, versioning: true do
  given!(:user) { create(:user) }
  given!(:project5) { create(:uncontracted_project, cd: '17M001A', name: 'efg', orderer_company_name: 'EFG') }
  given!(:project6) { create(:uncontracted_project, cd: '17S001A', name: 'hij', orderer_company_name: 'HIJ') }
  given!(:client) do
    create(
      :client,
      cd: 'CLIENT-1',
      company_name: 'clientA',
      department_name: 'client department name',
      address: 'client address',
      zip_code: 'client zip code',
      phone_number: 'client phone number',
    )
  end
  given!(:project_group) { create(:project_group, name: 'GroupA') }
  given!(:project1) do
    create(:contracted_project,
           cd: '16D001A',
           name: 'abc',
           contract_on: 5.days.ago,
           orderer_company_name: 'ABC',
           start_on: 1.day.ago,
           end_on: 1.month.since,
           status: :finished,
          )
  end
  given!(:project2) do
    create(:contracted_project,
           cd: '17D001A',
           name: 'bcd',
           orderer_company_name: 'BCD',
           contract_on: 2.days.ago,
           start_on: 1.week.ago,
           end_on: 3.days.ago,
           is_regular_contract: true,
          )
  end
  given!(:project3) do
    create(:contracted_project,
           cd: '17D002A',
           name: 'cde',
           orderer_company_name: 'CDE',
           contract_on: 4.days.ago,
           start_on: 3.days.ago,
           end_on: 1.day.ago,
          )
  end
  given!(:project4) do
    create(:contracted_project,
           cd: '17D001B',
           name: 'def',
           contract_on: 5.days.ago,
           orderer_company_name: 'DEF',
           start_on: 1.month.ago,
           end_on: 1.week.ago,
           status: :finished,
           is_regular_contract: true,
          )
  end

  background { login user, with_capybara: true }
  background { visit project_list_path }

  subject { page }

  scenario 'show' do
    is_expected.to have_header_title 'プロジェクト一覧'

    is_expected.to have_field           'search', with: ''
    is_expected.to have_content         '開始日'
    is_expected.to have_field           'start', with: ''
    is_expected.to have_content         '終了日'
    is_expected.to have_field           'end', with: ''
    is_expected.to have_button          '検索'
    is_expected.to have_checked_field   'all'
    is_expected.to have_unchecked_field 'contracted'
    is_expected.to have_unchecked_field 'uncontracted'
    is_expected.to have_checked_field   'progress'
    is_expected.to have_unchecked_field('finished', disabled: true)
    is_expected.to have_content 'プロジェクト新規作成'
    is_expected.to have_content 'ステータス'
    is_expected.to have_content 'ID'
    is_expected.to have_content '案件名'
    is_expected.to have_content '受注先会社名'
    is_expected.to have_content '開始日'
    is_expected.to have_content '終了日'
    is_expected.to have_content '契約日'
    is_expected.to have_content '金額'

    is_expected.to have_content project2.cd
    is_expected.to have_content I18n.t("enumerize.defaults.regular_contract")
    is_expected.to have_content I18n.t("enumerize.defaults.status.#{project2.status}")
    is_expected.to have_content project2.name
    is_expected.to have_content project2.orderer_company_name
    is_expected.to have_content project2.start_on
    is_expected.to have_content project2.end_on
    is_expected.to have_content project2.contract_on
    is_expected.to have_content project2.amount.to_s(:delimited)

    expect(all('.project_list__tbl__body__row td:nth-child(2)')[0]).to have_text project2.cd
    expect(all('.project_list__tbl__body__row td:nth-child(2)')[1]).to have_text project3.cd
  end

  context 'search' do
    scenario 'with blank' do
      skip "fail on wercker"
      uncheck 'progress'
      fill_in :search, with: ''

      is_expected.to have_content project1.cd
      is_expected.to have_content project2.cd
      is_expected.to have_content project3.cd
      is_expected.to have_content project4.cd
      is_expected.to have_content project5.cd
      is_expected.to have_content project6.cd

      expect(all('.project_list__tbl__body__row td:nth-child(2)')[0]).to have_text project1.cd
      expect(all('.project_list__tbl__body__row td:nth-child(2)')[1]).to have_text project2.cd
      expect(all('.project_list__tbl__body__row td:nth-child(2)')[2]).to have_text project3.cd
      expect(all('.project_list__tbl__body__row td:nth-child(2)')[3]).to have_text project4.cd
      expect(all('.project_list__tbl__body__row td:nth-child(2)')[4]).to have_text project5.cd
      expect(all('.project_list__tbl__body__row td:nth-child(2)')[5]).to have_text project6.cd
    end

    scenario 'with a part of cd' do
      skip "fail on wercker"
      uncheck 'progress'
      fill_in :search, with: 'PRO'

      is_expected.not_to have_content project1.cd
      is_expected.not_to have_content project2.cd
      is_expected.not_to have_content project3.cd
      is_expected.not_to have_content project4.cd
      is_expected.not_to have_content project5.cd
      is_expected.not_to have_content project6.cd
    end

    scenario 'with just a cd' do
      skip "fail on wercker"
      uncheck 'progress'
      fill_in :search, with: '16D001A'

      is_expected.to     have_content project1.cd
      is_expected.not_to have_content project2.cd
      is_expected.not_to have_content project3.cd
      is_expected.not_to have_content project4.cd
      is_expected.not_to have_content project5.cd
      is_expected.not_to have_content project6.cd
    end

    scenario 'with a part of name' do
      skip "fail on wercker"
      uncheck 'progress'
      fill_in :search, with: 'de'

      is_expected.not_to have_content project1.cd
      is_expected.not_to have_content project2.cd
      is_expected.to     have_content project3.cd
      is_expected.to     have_content project4.cd
      is_expected.not_to have_content project5.cd
      is_expected.not_to have_content project6.cd
    end

    scenario 'with a part of orderer_company_name' do
      skip "fail on wercker"
      uncheck 'progress'
      fill_in :search, with: 'E'

      is_expected.not_to have_content project1.cd
      is_expected.not_to have_content project2.cd
      is_expected.to     have_content project3.cd
      is_expected.to     have_content project4.cd
      is_expected.to     have_content project5.cd
      is_expected.not_to have_content project6.cd
    end

    scenario 'with multiple keywords' do
      skip "fail on wercker"
      uncheck 'progress'
      fill_in :search, with: '　 17D001B 　d　 　EF　 '

      is_expected.not_to have_content project1.cd
      is_expected.not_to have_content project2.cd
      is_expected.not_to have_content project3.cd
      is_expected.to     have_content project4.cd
      is_expected.not_to have_content project5.cd
      is_expected.not_to have_content project6.cd
    end
  end

  describe 'search_date' do
    scenario 'with blank' do
      skip "fail on wercker"
      uncheck 'progress'
      fill_in :start, with: ''
      fill_in :end, with: ''

      click_button '検索'

      is_expected.to have_content project1.cd
      is_expected.to have_content project2.cd
      is_expected.to have_content project3.cd
      is_expected.to have_content project4.cd
      is_expected.to have_content project5.cd
      is_expected.to have_content project6.cd
    end

    context 'with only start' do
      scenario 'when put 1 month ago' do
        skip "fail on wercker"
        uncheck 'progress'

        fill_in :start, with: 1.month.ago
        fill_in :end, with: ''

        click_button '検索'

        is_expected.to     have_content project1.cd
        is_expected.to     have_content project2.cd
        is_expected.to     have_content project3.cd
        is_expected.to     have_content project4.cd
        is_expected.not_to have_content project5.cd
        is_expected.not_to have_content project6.cd
      end

      scenario 'when put 1 week ago' do
        skip "fail on wercker"
        uncheck 'progress'

        fill_in :start, with: 1.week.ago
        fill_in :end, with: ''

        click_button '検索'

        is_expected.to     have_content project1.cd
        is_expected.to     have_content project2.cd
        is_expected.to     have_content project3.cd
        is_expected.not_to have_content project4.cd
        is_expected.not_to have_content project5.cd
        is_expected.not_to have_content project6.cd
      end
    end

    context 'with only end' do
      scenario 'when put 1 week ago' do
        skip "fail on wercker"
        uncheck 'progress'

        fill_in :start, with: ''
        fill_in :end, with: 1.week.ago

        click_button '検索'

        is_expected.not_to have_content project1.cd
        is_expected.not_to have_content project2.cd
        is_expected.not_to have_content project3.cd
        is_expected.to     have_content project4.cd
        is_expected.not_to have_content project5.cd
        is_expected.not_to have_content project6.cd
      end

      scenario 'when put 3 days ago' do
        skip "fail on wercker"
        uncheck 'progress'

        fill_in :start, with: ''
        fill_in :end, with: 3.days.ago

        click_button '検索'

        is_expected.not_to have_content project1.cd
        is_expected.to     have_content project2.cd
        is_expected.not_to have_content project3.cd
        is_expected.to     have_content project4.cd
        is_expected.not_to have_content project5.cd
        is_expected.not_to have_content project6.cd
      end
    end

    context 'with start and end' do
      scenario 'when put 1 month ago and 3 days ago' do
        skip "fail on wercker"
        uncheck 'progress'

        fill_in :start, with: 1.month.ago
        fill_in :end, with: 3.days.ago

        click_button '検索'

        is_expected.not_to have_content project1.cd
        is_expected.to     have_content project2.cd
        is_expected.not_to have_content project3.cd
        is_expected.to     have_content project4.cd
        is_expected.not_to have_content project5.cd
        is_expected.not_to have_content project6.cd
      end

      scenario 'when put 1 week ago and 3 days ago' do
        skip "fail on wercker"
        uncheck 'progress'

        fill_in :start, with: 1.week.ago
        fill_in :end, with: 3.days.ago

        click_button '検索'

        is_expected.not_to have_content project1.cd
        is_expected.to     have_content project2.cd
        is_expected.not_to have_content project3.cd
        is_expected.not_to have_content project4.cd
        is_expected.not_to have_content project5.cd
        is_expected.not_to have_content project6.cd
      end
    end
  end

  scenario 'link to a project show page when click row' do
    find("#project-#{project2.id}").click

    is_expected.to have_header_title 'プロジェクト情報'
  end

  context 'select contract type' do
    scenario 'with all' do
      skip "fail on wercker"
      uncheck 'progress'
      choose 'all'

      is_expected.to have_checked_field   'all'
      is_expected.to have_unchecked_field 'contracted'
      is_expected.to have_unchecked_field 'uncontracted'

      is_expected.to have_content project1.cd
      is_expected.to have_content project2.cd
      is_expected.to have_content project3.cd
      is_expected.to have_content project4.cd
      is_expected.to have_content project5.cd
      is_expected.to have_content project6.cd
    end

    scenario 'with contracted' do
      skip "fail on wercker"
      uncheck 'progress'
      choose 'contracted'

      is_expected.to have_unchecked_field 'all'
      is_expected.to have_checked_field   'contracted'
      is_expected.to have_unchecked_field 'uncontracted'

      is_expected.to     have_content project1.cd
      is_expected.to     have_content project2.cd
      is_expected.to     have_content project3.cd
      is_expected.to     have_content project4.cd
      is_expected.not_to have_content project5.cd
      is_expected.not_to have_content project6.cd
    end

    scenario 'with uncontracted' do
      skip "fail on wercker"
      uncheck 'progress'
      choose 'uncontracted'

      is_expected.to have_unchecked_field 'all'
      is_expected.to have_unchecked_field 'contracted'
      is_expected.to have_checked_field   'uncontracted'

      is_expected.not_to have_content project1.cd
      is_expected.not_to have_content project2.cd
      is_expected.not_to have_content project3.cd
      is_expected.not_to have_content project4.cd
      is_expected.to     have_content project5.cd
      is_expected.to     have_content project6.cd
    end
  end

  describe 'progress' do
    context 'when check progress' do
      scenario 'with all' do
        skip "fail on wercker"
        choose 'all'

        is_expected.not_to have_content project1.cd
        is_expected.to     have_content project2.cd
        is_expected.to     have_content project3.cd
        is_expected.not_to have_content project4.cd
        is_expected.not_to have_content project5.cd
        is_expected.not_to have_content project6.cd
      end

      scenario 'with contracted' do
        skip "fail on wercker"
        choose 'contracted'

        is_expected.not_to have_content project1.cd
        is_expected.to     have_content project2.cd
        is_expected.to     have_content project3.cd
        is_expected.not_to have_content project4.cd
        is_expected.not_to have_content project5.cd
        is_expected.not_to have_content project6.cd
      end

      scenario 'with uncontracted' do
        skip "fail on wercker"
        choose 'uncontracted'

        is_expected.not_to have_content project1.cd
        is_expected.not_to have_content project2.cd
        is_expected.not_to have_content project3.cd
        is_expected.not_to have_content project4.cd
        is_expected.not_to have_content project5.cd
        is_expected.not_to have_content project6.cd
      end
    end

    context 'when uncheck progress' do
      scenario 'with all' do
        skip "fail on wercker"
        uncheck 'progress'
        choose 'all'

        is_expected.to have_content project1.cd
        is_expected.to have_content project2.cd
        is_expected.to have_content project3.cd
        is_expected.to have_content project4.cd
        is_expected.to have_content project5.cd
        is_expected.to have_content project6.cd
      end

      scenario 'with contracted' do
        skip "fail on wercker"
        uncheck 'progress'
        choose 'contracted'

        is_expected.to     have_content project1.cd
        is_expected.to     have_content project2.cd
        is_expected.to     have_content project3.cd
        is_expected.to     have_content project4.cd
        is_expected.not_to have_content project5.cd
        is_expected.not_to have_content project6.cd
      end

      scenario 'with uncontracted' do
        skip "fail on wercker"
        uncheck 'progress'
        choose 'uncontracted'

        is_expected.not_to have_content project1.cd
        is_expected.not_to have_content project2.cd
        is_expected.not_to have_content project3.cd
        is_expected.not_to have_content project4.cd
        is_expected.to     have_content project5.cd
        is_expected.to     have_content project6.cd
      end
    end
  end

  describe 'finished' do
    context 'when check finished' do

      scenario 'with all' do
        skip "fail on wercker"
        uncheck 'progress'
        check 'finished'
        choose 'all'

        is_expected.to     have_content project1.cd
        is_expected.not_to have_content project2.cd
        is_expected.not_to have_content project3.cd
        is_expected.to     have_content project4.cd
        is_expected.not_to have_content project5.cd
        is_expected.not_to have_content project6.cd

        expect(find("#project-#{project1.id}")[:class]).to eq 'project_list__tbl__body__row project_list__tbl__body__row--finished'
        expect(find("#project-#{project4.id}")[:class]).to eq 'project_list__tbl__body__row project_list__tbl__body__row--finished'
      end

      scenario 'with contracted' do
        skip "fail on wercker"
        uncheck 'progress'
        check 'finished'
        choose 'contracted'

        is_expected.to     have_content project1.cd
        is_expected.not_to have_content project2.cd
        is_expected.not_to have_content project3.cd
        is_expected.to     have_content project4.cd
        is_expected.not_to have_content project5.cd
        is_expected.not_to have_content project6.cd
      end

      scenario 'with uncontracted' do
        skip "fail on wercker"
        uncheck 'progress'
        check 'finished'
        choose 'uncontracted'

        is_expected.not_to have_content project1.cd
        is_expected.not_to have_content project2.cd
        is_expected.not_to have_content project3.cd
        is_expected.not_to have_content project4.cd
        is_expected.not_to have_content project5.cd
        is_expected.not_to have_content project6.cd
      end
    end

    context 'when uncheck progress' do
      scenario 'with all' do
        skip "fail on wercker"
        uncheck 'progress'
        choose 'all'

        is_expected.to have_content project1.cd
        is_expected.to have_content project2.cd
        is_expected.to have_content project3.cd
        is_expected.to have_content project4.cd
        is_expected.to have_content project5.cd
        is_expected.to have_content project6.cd
      end

      scenario 'with contracted' do
        skip "fail on wercker"
        uncheck 'progress'
        choose 'contracted'

        is_expected.to     have_content project1.cd
        is_expected.to     have_content project2.cd
        is_expected.to     have_content project3.cd
        is_expected.to     have_content project4.cd
        is_expected.not_to have_content project5.cd
        is_expected.not_to have_content project6.cd
      end

      scenario 'with uncontracted' do
        skip "fail on wercker"
        uncheck 'progress'
        choose 'uncontracted'

        is_expected.not_to have_content project1.cd
        is_expected.not_to have_content project2.cd
        is_expected.not_to have_content project3.cd
        is_expected.not_to have_content project4.cd
        is_expected.to     have_content project5.cd
        is_expected.to     have_content project6.cd
      end
    end
  end

  scenario 'show Project New Modal when click show modal button' do
    is_expected.not_to have_css '.project_new__outer'
    click_on 'プロジェクト新規作成'
    is_expected.to     have_css '.project_new__outer'
  end

  context 'Project New Modal' do
    background do
      uncheck 'progress'
      click_button 'プロジェクト新規作成'
    end
    subject { find('.project_new') }

    describe 'form' do
      scenario 'click orderer fill button' do
        select 'CLIENT-1 clientA', from: :orderer_client_id
        find('.project_new__form__orderer .project_new__form__fill--btn').click
        wait_for_ajax

        is_expected.to have_field 'orderer_company_name'    , with: 'clientA'
        is_expected.to have_field 'orderer_department_name' , with: 'client department name'
        is_expected.to have_field 'orderer_address'         , with: 'client address'
        is_expected.to have_field 'orderer_zip_code'        , with: 'client zip code'
        is_expected.to have_field 'orderer_phone_number'    , with: 'client phone number'
      end

      scenario 'click billing fill button' do
        select 'CLIENT-1 clientA', from: :billing_client_id
        find('.project_new__form__billing .project_new__form__fill--btn').click
        wait_for_ajax

        is_expected.to have_field 'billing_company_name'    , with: 'clientA'
        is_expected.to have_field 'billing_department_name' , with: 'client department name'
        is_expected.to have_field 'billing_address'         , with: 'client address'
        is_expected.to have_field 'billing_zip_code'        , with: 'client zip code'
        is_expected.to have_field 'billing_phone_number'    , with: 'client phone number'
      end

      scenario 'click copy button' do
        fill_in :orderer_company_name    , with: 'test orderer company'
        fill_in :orderer_department_name , with: 'test orderer department'
        fill_in :orderer_personnel_names , with: 'test person1, test person2'
        fill_in :orderer_address         , with: 'test orderer address'
        fill_in :orderer_zip_code        , with: '1234567'
        fill_in :orderer_phone_number    , with: '1234567'
        fill_in :orderer_memo            , with: 'test orderer memo'

        is_expected.to have_field 'billing_company_name'    , with: ''
        is_expected.to have_field 'billing_department_name' , with: ''
        is_expected.to have_field 'billing_personnel_names' , with: ''
        is_expected.to have_field 'billing_address'         , with: ''
        is_expected.to have_field 'billing_zip_code'        , with: ''
        is_expected.to have_field 'billing_phone_number'    , with: ''
        is_expected.to have_field 'billing_memo'            , with: ''

        click_button '受注先から請求先に値をコピー'

        is_expected.to have_field 'billing_company_name'    , with: 'test orderer company'
        is_expected.to have_field 'billing_department_name' , with: 'test orderer department'
        is_expected.to have_field 'billing_personnel_names' , with: 'test person1, test person2'
        is_expected.to have_field 'billing_address'         , with: 'test orderer address'
        is_expected.to have_field 'billing_zip_code'        , with: '1234567'
        is_expected.to have_field 'billing_phone_number'    , with: '1234567'
        is_expected.to have_field 'billing_memo'            , with: ''
        is_expected.not_to have_field 'billing_memo'        , with: 'test orderer memo'
      end

      context "when 'contracted' is unchecked" do
        background { uncheck 'contracted' }

        scenario 'show' do
          is_expected.to     have_field 'group_id'
          is_expected.to     have_field 'cd'
          is_expected.to     have_field 'name'
          is_expected.to     have_field 'memo'
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
          is_expected.to     have_field 'orderer_phone_number'
          is_expected.to     have_field 'orderer_memo'
          is_expected.to     have_field 'billing_company_name'
          is_expected.to     have_field 'billing_department_name'
          is_expected.to     have_field 'billing_personnel_names'
          is_expected.to     have_field 'billing_address'
          is_expected.to     have_field 'billing_zip_code'
          is_expected.to     have_field 'billing_phone_number'
          is_expected.to     have_field 'billing_memo'
          is_expected.to     have_button '受注先から請求先に値をコピー'
          is_expected.to     have_button 'キャンセル'
          is_expected.to     have_button '登録'
        end

        scenario 'click submit button with correct values' do
          select 'GroupA', from: :group_id
          fill_in :cd         , with: '18D001A'
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
          fill_in :billing_phone_number    , with: '23456789'
          fill_in :billing_memo            , with: 'test billing memo'

          expect do
            click_button '登録'
            wait_for_ajax
          end.to change(Project, :count).by(1)

          is_expected.not_to  have_css 'project_new'
          expect(page).to     have_content 'test project'
        end

        scenario 'click submit button with uncorrect values' do
          select 'GroupA', from: :group_id
          fill_in :cd         , with: ' '
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
          fill_in :billing_phone_number    , with: '23456789'
          fill_in :billing_memo            , with: 'test billing memo'

          expect do
            click_button '登録'
            wait_for_ajax
          end.not_to change(Project, :count)

          is_expected.to have_unchecked_field 'contracted'
          select 'GroupA', from: :group_id
          is_expected.to have_field 'cd'                      , with: ' '
          is_expected.to have_field 'name'                    , with: 'test project'
          is_expected.to have_field 'memo'                    , with: 'test memo'
          is_expected.to have_field 'orderer_company_name'    , with: 'test orderer company'
          is_expected.to have_field 'orderer_department_name' , with: 'test orderer department'
          is_expected.to have_field 'orderer_personnel_names' , with: 'test person1, test person2'
          is_expected.to have_field 'orderer_address'         , with: 'test orderer address'
          is_expected.to have_field 'orderer_zip_code'        , with: '1234567'
          is_expected.to have_field 'orderer_phone_number'    , with: '123456789'
          is_expected.to have_field 'orderer_memo'            , with: 'test orderer memo'
          is_expected.to have_field 'billing_company_name'    , with: 'test billing company'
          is_expected.to have_field 'billing_department_name' , with: 'test billing department'
          is_expected.to have_field 'billing_personnel_names' , with: 'test person3, test person4'
          is_expected.to have_field 'billing_address'         , with: 'test billing address'
          is_expected.to have_field 'billing_zip_code'        , with: '2345678'
          is_expected.to have_field 'billing_phone_number'    , with: '23456789'
          is_expected.to have_field 'billing_memo'            , with: 'test billing memo'
        end
      end

      context "when 'contracted' is checked" do
        background { check 'contracted' }

        scenario 'show' do
          is_expected.to     have_field 'group_id'
          is_expected.to     have_field 'cd'
          is_expected.to     have_field 'name'
          is_expected.to     have_field 'memo'
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
          is_expected.to     have_field 'orderer_phone_number'
          is_expected.to     have_field 'orderer_memo'
          is_expected.to     have_field 'billing_company_name'
          is_expected.to     have_field 'billing_department_name'
          is_expected.to     have_field 'billing_personnel_names'
          is_expected.to     have_field 'billing_address'
          is_expected.to     have_field 'billing_zip_code'
          is_expected.to     have_field 'billing_phone_number'
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
          fill_in :cd         , with: '18D001A'
          fill_in :memo         , with: 'test memo'
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
          fill_in :billing_phone_number    , with: '23456789'
          fill_in :billing_memo            , with: 'test billing memo'

          expect do
            click_button '登録'
            wait_for_ajax
          end.to change(Project, :count).by(1)

          is_expected.not_to  have_css 'project_new'
          expect(page).to     have_content 'test project'
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
          fill_in :cd         , with: '18D001A'
          fill_in :memo         , with: 'test memo'
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
          fill_in :billing_phone_number    , with: '23456789'
          fill_in :billing_memo            , with: 'test billing memo'

          expect do
            click_button '登録'
            wait_for_ajax
          end.not_to change(Project, :count)

          is_expected.to have_checked_field 'contracted'
          select 'GroupA', from: :group_id
          is_expected.to have_field 'cd'                      , with: '18D001A'
          is_expected.to have_field 'name'                    , with: '  '
          is_expected.to have_field 'memo'                    , with: 'test memo'
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
          is_expected.to have_field 'orderer_phone_number'    , with: '123456789'
          is_expected.to have_field 'orderer_memo'            , with: 'test orderer memo'
          is_expected.to have_field 'billing_company_name'    , with: 'test billing company'
          is_expected.to have_field 'billing_department_name' , with: 'test billing department'
          is_expected.to have_field 'billing_personnel_names' , with: 'test person3, test person4'
          is_expected.to have_field 'billing_address'         , with: 'test billing address'
          is_expected.to have_field 'billing_zip_code'        , with: '2345678'
          is_expected.to have_field 'billing_phone_number'    , with: '23456789'
          is_expected.to have_field 'billing_memo'            , with: 'test billing memo'
        end
      end

      context "when select 'client_new'" do
        scenario 'click submit button with correct values' do
          select 'GroupA', from: :group_id
          fill_in :cd         , with: '18D001A'
          fill_in :name       , with: 'test project'
          fill_in :memo       , with: 'test memo'

          select '新規作成', from: :orderer_client_id

          fill_in :orderer_company_name    , with: 'test orderer company'
          fill_in :orderer_department_name , with: 'test orderer department'
          fill_in :orderer_personnel_names , with: 'test person1, test person2'
          fill_in :orderer_address         , with: 'test orderer address'
          fill_in :orderer_zip_code        , with: '1234567'
          fill_in :orderer_phone_number    , with: '1234567'
          fill_in :orderer_memo            , with: 'test orderer memo'
          fill_in :billing_company_name    , with: 'test billing company'
          fill_in :billing_department_name , with: 'test billing department'
          fill_in :billing_personnel_names , with: 'test person3, test person4'
          fill_in :billing_address         , with: 'test billing address'
          fill_in :billing_zip_code        , with: '2345678'
          fill_in :billing_phone_number    , with: '23456789'
          fill_in :billing_memo            , with: 'test billing memo'

          expect do
            click_button '登録'
            wait_for_ajax
          end.to change(Project, :count).by(1)

          is_expected.not_to  have_css 'project_new'
          expect(page).to     have_content 'test project'

          visit client_list_path
          expect(page).to     have_content 'test orderer company'
        end

        scenario 'click submit button with uncorrect values' do
          select 'GroupA', from: :group_id
          fill_in :cd         , with: '18D001A'
          fill_in :name       , with: 'test project'
          fill_in :memo       , with: 'test memo'

          select '新規作成', from: :orderer_client_id

          fill_in :orderer_company_name    , with: ''
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
          fill_in :billing_phone_number    , with: '23456789'
          fill_in :billing_memo            , with: 'test billing memo'

          expect do
            click_button '登録'
            wait_for_ajax
          end.not_to change(Project, :count)

          select 'GroupA', from: :group_id
          is_expected.to have_field 'cd'                      , with: '18D001A'
          is_expected.to have_field 'name'                    , with: 'test project'
          is_expected.to have_field 'memo'                    , with: 'test memo'
          is_expected.to have_field 'orderer_company_name'    , with: ''
          is_expected.to have_field 'orderer_department_name' , with: 'test orderer department'
          is_expected.to have_field 'orderer_personnel_names' , with: 'test person1, test person2'
          is_expected.to have_field 'orderer_address'         , with: 'test orderer address'
          is_expected.to have_field 'orderer_zip_code'        , with: '1234567'
          is_expected.to have_field 'orderer_phone_number'    , with: '123456789'
          is_expected.to have_field 'orderer_memo'            , with: 'test orderer memo'
          is_expected.to have_field 'billing_company_name'    , with: 'test billing company'
          is_expected.to have_field 'billing_department_name' , with: 'test billing department'
          is_expected.to have_field 'billing_personnel_names' , with: 'test person3, test person4'
          is_expected.to have_field 'billing_address'         , with: 'test billing address'
          is_expected.to have_field 'billing_zip_code'        , with: '2345678'
          is_expected.to have_field 'billing_phone_number'    , with: '23456789'
          is_expected.to have_field 'billing_memo'            , with: 'test billing memo'
        end
      end

      scenario 'click cancel' do
        fill_in :cd                      , with: '18D001A'
        fill_in :name                    , with: 'test project'
        fill_in :memo                    , with: 'test memo'
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
        fill_in :billing_phone_number    , with: '23456789'
        fill_in :billing_memo            , with: 'test billing memo'

        click_button 'キャンセル'

        is_expected.not_to  have_css '.project_new__outer'
        expect(page).not_to have_content 'test project'
      end
    end
  end
end
