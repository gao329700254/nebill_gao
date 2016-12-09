require 'rails_helper'

RSpec.feature 'Project Groups Page', js: true do
  given!(:user) { create(:user) }
  given!(:project_group1) { create(:project_group, name: 'Group1') }
  given!(:project_group2) { create(:project_group, name: 'Group2') }
  given!(:project1) { create(:project, group: project_group1) }
  given!(:project2) { create(:project, group: project_group2) }
  given!(:project3) { create(:project, group: nil) }

  background { login user, with_capybara: true }
  background { visit project_groups_path }

  subject { page }

  scenario 'show' do
    is_expected.to have_header_title 'プロジェクトグループ'

    is_expected.to have_field 'name'
    is_expected.to have_button '登録'

    expect(find('.project_groups__list')).to have_content project_group1.name
    expect(find('.project_groups__list')).to have_content project_group2.name

    expect(find("#project_group-#{project_group1.id}")).to have_content "#{project1.cd}#{project1.name}"
    expect(find("#project_group-#{project_group2.id}")).to have_content "#{project2.cd}#{project2.name}"
    expect(find("#project_group-0")).to                    have_content "#{project3.cd}#{project3.name}"
  end

  scenario 'click create button with corrent value' do
    fill_in :name, with: 'Group3'

    expect do
      click_button '登録'
      wait_for_ajax
    end.to change(ProjectGroup, :count).by(1)

    is_expected.to have_field 'name', with: ''

    expect(find('.project_groups__list')).to have_content 'Group3'
  end

  scenario 'click create button with uncorrent value' do
    fill_in :name, with: '  '

    expect do
      click_button '登録'
      wait_for_ajax
    end.not_to change(ProjectGroup, :count)

    is_expected.to have_field 'name', with: '  '
  end

  scenario 'drag and drop a porject to other project group' do
    pending "don't use #drag_to"

    source = page.find("#project-#{project1.id}")
    target = page.find("#project-#{project2.id}")

    source.drag_to(target)
    wait_for_ajax

    expect(find("#project_group-#{project_group2.id}")).to have_content "#{project1.cd}#{project1.name}"
    project1.reload
    expect(project1.group).to eq project_group2
  end
end
