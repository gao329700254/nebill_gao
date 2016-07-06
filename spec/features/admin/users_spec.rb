require 'rails_helper'

RSpec.feature 'Admin Users Page', js: true do

  context 'with loginned not admin user' do
    given!(:user) { create(:user) }

    background { login user, with_capybara: true }
    background { visit admin_users_path }

    subject { page }

    scenario 'show' do
      is_expected.to have_header_title 'HOME'
    end
  end

  context 'with loginned admin user' do
    given!(:admin_user) { create(:admin_user) }
    given!(:user) { create(:user) }
    given!(:un_register_user) { create(:un_register_user) }

    background { login admin_user, with_capybara: true }
    background { visit admin_users_path }

    subject { page }

    scenario 'show' do
      is_expected.to have_header_title 'ユーザ管理'

      is_expected.to have_field 'email'
      is_expected.to have_select 'role', options: %w(一般 上長), selected: '一般'
      is_expected.to have_button '登録'

      # HACK(rairei): カスタムマッチャーで定義するときれいになりそう
      expect(all('.user_list__tbl__head__row th:nth-child(1)')[0]).to have_content '名前'
      expect(all('.user_list__tbl__head__row th:nth-child(2)')[0]).to have_content 'メールアドレス'
      expect(all('.user_list__tbl__head__row th:nth-child(3)')[0]).to have_content '管理者'

      expect(all('.user_list__tbl__body__row td:nth-child(1)')[0]).to have_content admin_user.name
      expect(all('.user_list__tbl__body__row td:nth-child(2)')[0]).to have_content admin_user.email
      expect(all('.user_list__tbl__body__row td:nth-child(3)')[0]).to have_text '✔︎'
      expect(all('.user_list__tbl__body__row td:nth-child(1)')[1]).to have_content user.name
      expect(all('.user_list__tbl__body__row td:nth-child(2)')[1]).to have_content user.email
      expect(all('.user_list__tbl__body__row td:nth-child(3)')[1]).not_to have_text '✔︎'
      expect(all('.user_list__tbl__body__row td:nth-child(1)')[2]).to have_content un_register_user.name
      expect(all('.user_list__tbl__body__row td:nth-child(2)')[2]).to have_content un_register_user.email
      expect(all('.user_list__tbl__body__row td:nth-child(3)')[2]).not_to have_text '✔︎'
    end

    scenario 'click create button with corrent value' do
      fill_in :email, with: 'foo@example.com'
      select '上長', from: 'role'
      check :is_admin

      expect do
        click_button '登録'
        wait_for_ajax
      end.to change(User, :count).by(1)

      user = User.find_by(email: 'foo@example.com')

      expect(user.role).to eq 'superior'
      expect(user.is_admin).to eq true

      is_expected.to have_field 'email', with: ''
      is_expected.to have_select 'role', selected: '一般'
      is_expected.to have_unchecked_field 'is_admin'
      expect(find('.user_list')).to have_content 'foo@example.com'
    end

    scenario 'click create button with uncorrent value' do
      fill_in :email, with: 'foo@'
      check :is_admin

      expect do
        click_button '登録'
        wait_for_ajax
      end.not_to change(User, :count)

      is_expected.to have_field 'email', with: 'foo@'
      is_expected.to have_checked_field 'is_admin'
    end
  end
end
