require 'rails_helper'

RSpec.feature 'Project List Page', js: true do

  let!(:project1) { create(:contracted_project,    contract_on: 5.days.ago) }
  let!(:project2) { create(:contracted_project,    contract_on: 2.days.ago) }
  let!(:project3) { create(:contracted_project,    contract_on: 4.days.ago) }
  let!(:project4) { create(:un_contracted_project, contract_on: 3.days.ago) }
  let!(:project5) { create(:un_contracted_project, contract_on: 1.day.ago) }

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

    expect(all('.project_list__tbl__tr td:first-child')[0]).to have_text project1.key
    expect(all('.project_list__tbl__tr td:first-child')[1]).to have_text project3.key
    expect(all('.project_list__tbl__tr td:first-child')[2]).to have_text project4.key
    expect(all('.project_list__tbl__tr td:first-child')[3]).to have_text project2.key
    expect(all('.project_list__tbl__tr td:first-child')[4]).to have_text project5.key
  end
end
