require 'rails_helper'

RSpec.feature 'Admin User Show Page', js: true do

  context 'with loginned not admin user' do
    given!(:user) { create(:user) }
    background { login user, with_capybara: true }
    background { visit admin_user_show_path(user) }
    subject { page }

    scenario 'show' do
      is_expected.to have_css '#project_list'
    end
  end

  context 'with loginned admin user' do
    given!(:admin_user) { create(:admin_user) }
    given!(:user) { create(:user) }
    given!(:un_register_user) { create(:un_register_user) }

    background { login admin_user, with_capybara: true }
    background do
      visit admin_user_show_path(user)
      wait_for_ajax
    end

    subject { page }

    scenario 'show' do
      is_expected.to have_header_title 'ユーザ情報'
      is_expected.to have_content '最終更新日時: ' + user.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
    end

    describe 'form' do
      subject { find('.user_show__form') }

      scenario 'should show user attributes' do
        is_expected.to have_field      'email'          , disabled: true, with: user.email
        is_expected.to have_field      'role'           , disabled: true, with: user.role
        is_expected.to have_button     '編集'
        is_expected.not_to have_button 'キャンセル'
        is_expected.not_to have_button '更新'
      end

      context 'when click edit button' do
        background { click_button '編集' }

        scenario 'should have edit user fields' do
          is_expected.to     have_field  'email'          , disabled: false, with: user.email
          is_expected.to     have_field  'role'           , disabled: false, with: user.role
          is_expected.not_to have_button '編集'
          is_expected.to     have_button 'キャンセル'
          is_expected.to     have_button '更新'
        end

        scenario 'should not update when click cancel button' do
          original_email           = user.email
          original_role            = user.role

          fill_in :email           , with: 'foo@'
          select '管理者'           , from: 'role'

          expect do
            click_button 'キャンセル'
            wait_for_ajax
          end.not_to change { user.reload && user.updated_at }

          is_expected.to have_field 'email'          , disabled: true, with: original_email
          is_expected.to have_field 'role'           , disabled: true, with: original_role
        end

        scenario 'should update when click submit button with correct values' do
          fill_in :email           , with: 'foo@example.com'
          select '管理者'           , from: 'role'

          expect do
            click_button '更新'
            wait_for_ajax
          end.to change { user.reload && user.updated_at }

          is_expected.to have_field 'email'          , disabled: true, with: 'foo@example.com'
          is_expected.to have_field 'role'           , disabled: true, with: 'admin'
        end

        scenario 'should not update when click submit button with uncorrect values' do
          fill_in :email    , with: ''
          select '管理者'    , from: 'role'

          expect do
            click_button '更新'
            wait_for_ajax
          end.not_to change { user.reload && user.updated_at }

          is_expected.to have_field 'email'          , disabled: false, with: ''
          is_expected.to have_field 'role'           , disabled: false, with: 'admin'
        end
      end
    end
  end
end
