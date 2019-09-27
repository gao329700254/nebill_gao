require 'rails_helper'

RSpec.feature 'Project Index Page', js: true do
  subject { page }

  given!(:user)      { create(:user) }
  given!(:project_A) { create(:contracted_project, cd: '11D111', name: "project_A", status: "receive_order") }
  given!(:project_B) { create(:contracted_project, cd: '22D222', name: "project_B", status: "finished") }
  given!(:project_C) { create(:uncontracted_project, cd: '33D333', name: "project_C", unprocessed: true) }

  background { login user, with_capybara: true }
  background do
    visit project_list_path
    wait_for_ajax
  end

  context 'by default' do
    scenario 'selected radio-button for all' do
      is_expected.to have_checked_field 'all_contract_type'
      is_expected.to have_checked_field 'all_pjt_status'
    end

    scenario 'show all projects' do
      is_expected.to have_content project_A.name
      is_expected.to have_content project_B.name
      is_expected.to have_content project_C.name
    end
  end

  context 'searching by contract status' do
    scenario 'choose "契約済" button shows 2 projects' do
      choose '契約済'
      wait_for_ajax

      is_expected.to     have_content project_A.name
      is_expected.to     have_content project_B.name
      is_expected.not_to have_content project_C.name
    end

    scenario 'choose "未契約" button shows a project' do
      choose '未契約'
      wait_for_ajax

      is_expected.not_to have_content project_A.name
      is_expected.not_to have_content project_B.name
      is_expected.to     have_content project_C.name
    end
  end

  context 'searching by project status' do
    scenario 'choose "現在進行中" show a project' do
      choose '現在進行中'
      wait_for_ajax

      is_expected.to     have_content project_A.name
      is_expected.not_to have_content project_B.name
      is_expected.not_to have_content project_C.name
    end

    scenario 'choose "終了" show a project' do
      choose '終了'
      wait_for_ajax

      is_expected.not_to have_content project_A.name
      is_expected.to     have_content project_B.name
      is_expected.not_to have_content project_C.name
    end

    scenario 'choose "失注" show a project' do
      choose '失注'
      wait_for_ajax

      is_expected.not_to have_content project_A.name
      is_expected.not_to have_content project_B.name
      is_expected.to     have_content project_C.name
    end
  end

  context 'searching by contract status && project status' do
    scenario 'choose "契約済" && "現在進行中" show a project' do
      choose '契約済'
      choose '現在進行中'
      wait_for_ajax

      is_expected.to     have_content project_A.name
      is_expected.not_to have_content project_B.name
      is_expected.not_to have_content project_C.name
    end

    scenario 'choose "未契約" && "終了" show no project' do
      choose '未契約'
      choose '終了'
      wait_for_ajax

      is_expected.not_to have_content project_A.name
      is_expected.not_to have_content project_B.name
      is_expected.not_to have_content project_C.name
    end

    scenario 'choose "未契約" && "失注" show a project' do
      choose '未契約'
      choose '失注'
      wait_for_ajax

      is_expected.not_to have_content project_A.name
      is_expected.not_to have_content project_B.name
      is_expected.to     have_content project_C.name
    end
  end
end
