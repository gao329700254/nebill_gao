require 'rails_helper'

RSpec.feature 'Bill List Page', js: true do
  given!(:user) { create(:user) }
  given!(:project1) { create(:contracted_project,   key: 'KEY-1', name: 'abc', billing_company_name: 'ABC', contract_on: 2.days.ago) }
  given!(:project2) { create(:uncontracted_project, key: 'KEY-5', name: 'def', billing_company_name: 'DEF', contract_on: 1.day.ago)  }
  given!(:bill1) { create(:bill, key: '2016040199', project: project1) }
  given!(:bill2) { create(:bill, key: '2016040300', project: project2) }
  given!(:bill3) { create(:bill, key: '2016040299', project: project1) }

  background { login user, with_capybara: true }
  background { visit bill_list_path }

  subject { page }

  scenario 'show' do
    is_expected.to have_header_title '請求一覧'

    is_expected.to have_field 'search', with: ''
    is_expected.to have_content '請求番号'
    is_expected.to have_content 'プロジェクト'
    is_expected.to have_content '請求先会社名'
    is_expected.to have_content '金額'
    is_expected.to have_content '支払日'
    is_expected.to have_content '入金日'

    is_expected.to have_content bill1.key
    is_expected.to have_content bill1.project.name
    is_expected.to have_content bill1.project.billing_company_name
    is_expected.to have_content bill1.project.amount
    is_expected.to have_content bill1.payment_on
    is_expected.to have_content bill1.deposit_on

    is_expected.to have_content bill2.key
    is_expected.to have_content bill3.key

    expect(all('.bill_list__tbl__body__row td:first-child')[0]).to have_text bill2.key
    expect(all('.bill_list__tbl__body__row td:first-child')[1]).to have_text bill3.key
    expect(all('.bill_list__tbl__body__row td:first-child')[2]).to have_text bill1.key
  end

  context 'search' do
    scenario 'with blank' do
      fill_in :search, with: ''
      is_expected.to have_content bill1.key
      is_expected.to have_content bill2.key
      is_expected.to have_content bill3.key
    end

    scenario 'with a part of key' do
      fill_in :search, with: '0401'
      is_expected.to     have_content bill1.key
      is_expected.not_to have_content bill2.key
      is_expected.not_to have_content bill3.key
    end

    scenario 'with a part of project name' do
      fill_in :search, with: 'bc'
      is_expected.to     have_content bill1.key
      is_expected.not_to have_content bill2.key
      is_expected.to     have_content bill3.key
    end

    scenario 'with a part of billing_company_name' do
      fill_in :search, with: 'E'
      is_expected.not_to have_content bill1.key
      is_expected.to     have_content bill2.key
      is_expected.not_to have_content bill3.key
    end

    scenario 'with multiple keywords' do
      fill_in :search, with: '　 2016 　d　 　EF　 '
      is_expected.not_to have_content bill1.key
      is_expected.to     have_content bill2.key
      is_expected.not_to have_content bill3.key
    end
  end
end
