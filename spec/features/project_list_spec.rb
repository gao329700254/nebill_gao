require 'rails_helper'

RSpec.feature 'Project List Page', js: true do
  given!(:user) { create(:user) }
  given!(:project1) { create(:contracted_project,   cd: 'PROJECT-1', name: 'abc', orderer_company_name: 'ABC', contract_on: 5.days.ago) }
  given!(:project2) { create(:contracted_project,   cd: 'PROJECT-2', name: 'bcd', orderer_company_name: 'BCD', contract_on: 2.days.ago) }
  given!(:project3) { create(:contracted_project,   cd: 'PROJECT-3', name: 'cde', orderer_company_name: 'CDE', contract_on: 4.days.ago) }
  given!(:project4) { create(:uncontracted_project, cd: 'PROJECT-4', name: 'def', orderer_company_name: 'DEF', contract_on: 3.days.ago) }
  given!(:project5) { create(:uncontracted_project, cd: 'PROJECT-5', name: 'efg', orderer_company_name: 'EFG', contract_on: 1.day.ago)  }

  background { login user, with_capybara: true }
  background { visit project_list_path }

  subject { page }

  scenario 'show' do
    is_expected.to have_header_title 'プロジェクト一覧'

    is_expected.to have_field 'search', with: ''
    is_expected.to have_checked_field   'all'
    is_expected.to have_unchecked_field 'contracted'
    is_expected.to have_unchecked_field 'uncontracted'
    is_expected.to have_content 'ID'
    is_expected.to have_content '名前'
    is_expected.to have_content '受注先会社名'
    is_expected.to have_content '開始日'
    is_expected.to have_content '終了日'
    is_expected.to have_content '契約日'

    is_expected.to have_content project1.cd
    is_expected.to have_content project1.name
    is_expected.to have_content project1.orderer_company_name
    is_expected.to have_content project1.start_on
    is_expected.to have_content project1.end_on
    is_expected.to have_content project1.contract_on

    is_expected.to have_content project2.cd
    is_expected.to have_content project3.cd
    is_expected.to have_content project4.cd
    is_expected.to have_content project5.cd

    expect(all('.project_list__tbl__body__row td:first-child')[0]).to have_text project1.cd
    expect(all('.project_list__tbl__body__row td:first-child')[1]).to have_text project3.cd
    expect(all('.project_list__tbl__body__row td:first-child')[2]).to have_text project4.cd
    expect(all('.project_list__tbl__body__row td:first-child')[3]).to have_text project2.cd
    expect(all('.project_list__tbl__body__row td:first-child')[4]).to have_text project5.cd
  end

  context 'search' do
    scenario 'with blank' do
      fill_in :search, with: ''
      is_expected.to have_content project1.cd
      is_expected.to have_content project2.cd
      is_expected.to have_content project3.cd
      is_expected.to have_content project4.cd
      is_expected.to have_content project5.cd
    end

    scenario 'with a part of cd' do
      fill_in :search, with: 'PRO'
      is_expected.not_to have_content project1.cd
      is_expected.not_to have_content project2.cd
      is_expected.not_to have_content project3.cd
      is_expected.not_to have_content project4.cd
      is_expected.not_to have_content project5.cd
    end

    scenario 'with just a cd' do
      fill_in :search, with: 'PROJECT-1'
      is_expected.to     have_content project1.cd
      is_expected.not_to have_content project2.cd
      is_expected.not_to have_content project3.cd
      is_expected.not_to have_content project4.cd
      is_expected.not_to have_content project5.cd
    end

    scenario 'with a part of name' do
      fill_in :search, with: 'de'
      is_expected.not_to have_content project1.cd
      is_expected.not_to have_content project2.cd
      is_expected.to     have_content project3.cd
      is_expected.to     have_content project4.cd
      is_expected.not_to have_content project5.cd
    end

    scenario 'with a part of orderer_company_name' do
      fill_in :search, with: 'E'
      is_expected.not_to have_content project1.cd
      is_expected.not_to have_content project2.cd
      is_expected.to     have_content project3.cd
      is_expected.to     have_content project4.cd
      is_expected.to     have_content project5.cd
    end

    scenario 'with multiple keywords' do
      fill_in :search, with: '　 PROJECT-4 　d　 　EF　 '
      is_expected.not_to have_content project1.cd
      is_expected.not_to have_content project2.cd
      is_expected.not_to have_content project3.cd
      is_expected.to     have_content project4.cd
      is_expected.not_to have_content project5.cd
    end
  end

  scenario 'link to a project show page when click row' do
    find("#project-#{project1.id}").click

    is_expected.to have_header_title 'プロジェクト情報'
  end

  context 'select contract type' do
    scenario 'with all' do
      choose 'all'
      is_expected.to have_checked_field   'all'
      is_expected.to have_unchecked_field 'contracted'
      is_expected.to have_unchecked_field 'uncontracted'

      is_expected.to have_content project1.cd
      is_expected.to have_content project2.cd
      is_expected.to have_content project3.cd
      is_expected.to have_content project4.cd
      is_expected.to have_content project5.cd
    end

    scenario 'with contracted' do
      choose 'contracted'
      is_expected.to have_unchecked_field 'all'
      is_expected.to have_checked_field   'contracted'
      is_expected.to have_unchecked_field 'uncontracted'

      is_expected.to     have_content project1.cd
      is_expected.to     have_content project2.cd
      is_expected.to     have_content project3.cd
      is_expected.not_to have_content project4.cd
      is_expected.not_to have_content project5.cd
    end

    scenario 'with uncontracted' do
      choose 'uncontracted'
      is_expected.to have_unchecked_field 'all'
      is_expected.to have_unchecked_field 'contracted'
      is_expected.to have_checked_field   'uncontracted'

      is_expected.not_to have_content project1.cd
      is_expected.not_to have_content project2.cd
      is_expected.not_to have_content project3.cd
      is_expected.to     have_content project4.cd
      is_expected.to     have_content project5.cd
    end
  end
end
