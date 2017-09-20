require 'rails_helper'

RSpec.feature 'Bill List Page', js: true do
  given!(:user) { create(:user) }
  given!(:project1) { create(:contracted_project,   cd: 'CD-1', name: 'abc', billing_company_name: 'ABC', contract_on: 2.days.ago) }
  given!(:project2) { create(:uncontracted_project, cd: 'CD-5', name: 'def', billing_company_name: 'DEF')  }
  given!(:bill1) { create(:bill, cd: '2016040199', project: project1, deposit_on: '2016-01-05', bill_on: 1.month.ago) }
  given!(:bill2) { create(:bill, cd: '2016040300', project: project2, bill_on: 1.week.ago) }
  given!(:bill3) { create(:bill, cd: '2016040299', project: project1, bill_on: 1.day.ago) }

  background { login user, with_capybara: true }
  background { visit bill_list_path }

  subject { page }

  scenario 'show' do
    is_expected.to have_header_title '請求一覧'

    is_expected.to have_field 'search', with: ''
    is_expected.to have_content '請求日検索'
    is_expected.to have_field   'start', with: ''
    is_expected.to have_field   'end', with: ''
    is_expected.to have_button  '検索'
    is_expected.to have_content '請求番号'
    is_expected.to have_content 'プロジェクト'
    is_expected.to have_content '請求先会社名'
    is_expected.to have_content '請求金額'
    is_expected.to have_content '支払条件'
    is_expected.to have_content '入金日'

    is_expected.to have_content bill1.cd
    is_expected.to have_content bill1.amount
    is_expected.to have_content bill1.project.name
    is_expected.to have_content bill1.project.billing_company_name
    is_expected.to have_content I18n.t("enumerize.defaults.payment_type.#{bill1.payment_type}")
    is_expected.to have_content bill1.deposit_on

    is_expected.to have_content bill2.cd
    is_expected.to have_content bill3.cd

    expect(all('.bill_list__tbl__body__row td:first-child')[0]).to have_text bill2.cd
    expect(all('.bill_list__tbl__body__row td:first-child')[1]).to have_text bill3.cd
    expect(all('.bill_list__tbl__body__row td:first-child')[2]).to have_text bill1.cd

    expect(find("#bill-#{bill1.id}")[:class]).to eq 'bill_list__tbl__body__row bill_list__tbl__body__row--deposited'
    expect(find("#bill-#{bill2.id}")[:class]).to eq 'bill_list__tbl__body__row'
    expect(find("#bill-#{bill3.id}")[:class]).to eq 'bill_list__tbl__body__row'
  end

  context 'search' do
    scenario 'with blank' do
      fill_in :search, with: ''
      is_expected.to have_content bill1.cd
      is_expected.to have_content bill2.cd
      is_expected.to have_content bill3.cd
    end

    scenario 'with a part of cd' do
      fill_in :search, with: '0401'
      is_expected.to     have_content bill1.cd
      is_expected.not_to have_content bill2.cd
      is_expected.not_to have_content bill3.cd
    end

    scenario 'with a part of project name' do
      fill_in :search, with: 'bc'
      is_expected.to     have_content bill1.cd
      is_expected.not_to have_content bill2.cd
      is_expected.to     have_content bill3.cd
    end

    scenario 'with a part of billing_company_name' do
      fill_in :search, with: 'E'
      is_expected.not_to have_content bill1.cd
      is_expected.to     have_content bill2.cd
      is_expected.not_to have_content bill3.cd
    end

    scenario 'with multiple keywords' do
      fill_in :search, with: '　 2016 　d　 　EF　 '
      is_expected.not_to have_content bill1.cd
      is_expected.to     have_content bill2.cd
      is_expected.not_to have_content bill3.cd
    end
  end

  describe 'search_bill_on' do
    scenario 'with blank' do
      fill_in :start, with: ''
      fill_in :end, with: ''

      click_button '検索'
      wait_for_ajax

      is_expected.to have_content bill1.cd
      is_expected.to have_content bill2.cd
      is_expected.to have_content bill3.cd
    end

    context 'with only start' do
      scenario 'when put 1 week ago' do
        fill_in :start, with: 1.week.ago
        fill_in :end, with: ''

        click_button '検索'
        wait_for_ajax

        is_expected.not_to have_content bill1.cd
        is_expected.to     have_content bill2.cd
        is_expected.to     have_content bill3.cd
      end

      scenario 'when put 1 day ago' do
        fill_in :start, with: 1.day.ago
        fill_in :end, with: ''

        click_button '検索'
        wait_for_ajax

        is_expected.not_to have_content bill1.cd
        is_expected.not_to have_content bill2.cd
        is_expected.to     have_content bill3.cd
      end
    end

    context 'with only end' do
      scenario 'when put 1 week ago' do
        fill_in :start, with: ''
        fill_in :end, with: 1.week.ago

        click_button '検索'
        wait_for_ajax

        is_expected.to     have_content bill1.cd
        is_expected.to     have_content bill2.cd
        is_expected.not_to have_content bill3.cd
      end

      scenario 'when put 1 day ago' do
        fill_in :start, with: ''
        fill_in :end, with: 1.day.ago

        click_button '検索'
        wait_for_ajax

        is_expected.to     have_content bill1.cd
        is_expected.to     have_content bill2.cd
        is_expected.to     have_content bill3.cd
      end
    end

    context 'with start and end' do
      scenario 'when put 1 month ago and 1 day ago' do
        fill_in :start, with: 1.month.ago
        fill_in :end, with: 1.day.ago

        click_button '検索'
        wait_for_ajax

        is_expected.to     have_content bill1.cd
        is_expected.to     have_content bill2.cd
        is_expected.to     have_content bill3.cd
      end

      scenario 'when put 1 week ago and 1 day ago' do
        fill_in :start, with: 1.week.ago
        fill_in :end, with: 1.day.ago

        click_button '検索'
        wait_for_ajax

        is_expected.not_to have_content bill1.cd
        is_expected.to     have_content bill2.cd
        is_expected.to     have_content bill3.cd
      end
    end
  end

  scenario 'link to a bill show page when click row' do
    find("#bill-#{bill1.id}").click

    is_expected.to have_header_title '請求情報'
  end
end
