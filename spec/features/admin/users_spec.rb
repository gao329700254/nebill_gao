require 'rails_helper'

RSpec.feature 'Admin Users Page', js: true do

  context 'with loginned not admin user' do
    given!(:user) { create(:user) }

    background { login user, with_capybara: true }
    background { visit admin_users_path }

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
      visit admin_users_path
      wait_for_ajax
    end

    subject { page }

    scenario 'show' do
      is_expected.to have_header_title 'ユーザ管理'
      is_expected.to have_button 'ユーザ新規作成'

      # HACK(rairei): カスタムマッチャーで定義するときれいになりそう
      expect(all('.user_list__tbl__head__row th:nth-child(1)')[0]).to have_content '名前'
      expect(all('.user_list__tbl__head__row th:nth-child(2)')[0]).to have_content 'メールアドレス'
      expect(all('.user_list__tbl__head__row th:nth-child(3)')[0]).to have_content 'ロール'
      expect(all('.user_list__tbl__head__row th:nth-child(4)')[0]).to have_content '承認者'

      expect(all('.user_list__tbl__body__row td:nth-child(1)')[0]).to have_content admin_user.name
      expect(all('.user_list__tbl__body__row td:nth-child(2)')[0]).to have_content admin_user.email
      expect(all('.user_list__tbl__body__row td:nth-child(3)')[0]).to have_content admin_user.role_text
      expect(all('.user_list__tbl__body__row td:nth-child(4)')[0]).to have_content admin_user.default_allower

      expect(all('.user_list__tbl__body__row td:nth-child(1)')[1]).to have_content user.name
      expect(all('.user_list__tbl__body__row td:nth-child(2)')[1]).to have_content user.email
      expect(all('.user_list__tbl__body__row td:nth-child(3)')[1]).to have_content user.role_text
      expect(all('.user_list__tbl__body__row td:nth-child(4)')[1]).to have_content user.default_allower

      expect(all('.user_list__tbl__body__row td:nth-child(1)')[2]).to have_content un_register_user.name
      expect(all('.user_list__tbl__body__row td:nth-child(2)')[2]).to have_content un_register_user.email
      expect(all('.user_list__tbl__body__row td:nth-child(3)')[2]).to have_content un_register_user.role_text
      expect(all('.user_list__tbl__body__row td:nth-child(4)')[2]).to have_content un_register_user.default_allower
    end

    scenario 'link to an admin user show page when click row' do
      find("#user-#{user.id}").click
    end

    scenario 'show User New Modal when click show modal button' do
      is_expected.not_to have_css '.user_new__outer'
      click_on 'ユーザ新規作成'
      is_expected.to     have_css '.user_new__outer'
    end

    context 'User New Modal' do
      background { click_button 'ユーザ新規作成' }
      subject { find('.user_new') }

      scenario 'show' do
        is_expected.to have_field 'email'
        is_expected.to have_field 'role'
        is_expected.to have_button '登録'
        is_expected.to have_button 'キャンセル'
      end

      scenario 'click submit button with correct values' do
        fill_in :email           , with: 'foo@example.com'
        select '管理者'           , from: 'role'

        expect do
          click_button '登録'
          wait_for_ajax
        end.to change(User, :count)

        is_expected.not_to have_css '.user_new'
      end

      scenario 'click submit button with uncorrect values' do
        fill_in :email           , with: 'foo@'
        select '管理者'           , from: 'role'

        expect do
          click_button '登録'
          wait_for_ajax
        end.not_to change(User, :count)

        is_expected.to have_field 'email'                , with: 'foo@'
        is_expected.to have_field 'role'                 , with: 'admin'
      end

      scenario 'click cancel' do
        is_expected.to     have_css '.user_new__outer'
        click_button 'キャンセル'
        is_expected.not_to have_css '.user_new__outer'
      end
    end
  end
end
