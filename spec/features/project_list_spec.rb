require 'rails_helper'

RSpec.feature 'Project List Page', js: true do
  given!(:user) { create(:user) }
  given!(:project1) { create(:contracted_project,   contract_on: 5.days.ago) }
  given!(:project2) { create(:contracted_project,   contract_on: 2.days.ago) }
  given!(:project3) { create(:contracted_project,   contract_on: 4.days.ago) }
  given!(:project4) { create(:uncontracted_project, contract_on: 3.days.ago) }
  given!(:project5) { create(:uncontracted_project, contract_on: 1.day.ago) }

  background { login user, with_capybara: true }
  background { visit project_list_path }

  subject { page }

  scenario 'show' do
    is_expected.to have_header_title 'プロジェクト一覧'

    is_expected.to have_content 'ID'
    is_expected.to have_content '名前'
    is_expected.to have_content '受注先会社名'
    is_expected.to have_content '開始日'
    is_expected.to have_content '終了日'
    is_expected.to have_content '契約日'

    is_expected.to have_content project1.key
    is_expected.to have_content project1.name
    is_expected.to have_content project1.orderer_company_name
    is_expected.to have_content project1.start_on
    is_expected.to have_content project1.end_on
    is_expected.to have_content project1.contract_on

    is_expected.to have_content project2.key
    is_expected.to have_content project3.key
    is_expected.to have_content project4.key
    is_expected.to have_content project5.key

    expect(all('.project_list__tbl__body__row td:first-child')[0]).to have_text project1.key
    expect(all('.project_list__tbl__body__row td:first-child')[1]).to have_text project3.key
    expect(all('.project_list__tbl__body__row td:first-child')[2]).to have_text project4.key
    expect(all('.project_list__tbl__body__row td:first-child')[3]).to have_text project2.key
    expect(all('.project_list__tbl__body__row td:first-child')[4]).to have_text project5.key
  end

  scenario 'link to a project show page when click row' do
    find("#project-#{project1.id}").click

    is_expected.to have_header_title 'プロジェクト詳細'
  end
end
