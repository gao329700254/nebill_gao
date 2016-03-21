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

    background { login admin_user, with_capybara: true }
    background { visit admin_users_path }

    subject { page }

    scenario 'show' do
      is_expected.to have_header_title 'ユーザ管理'

      is_expected.to have_field 'email'
      is_expected.to have_button '登録'
    end

    scenario 'click create button with corrent value' do
      fill_in :email, with: 'foo@example.com'
      check :is_admin

      expect do
        click_button '登録'
        wait_for_ajax
      end.to change(User, :count).by(1)

      is_expected.to have_field 'email', with: ''
      is_expected.to have_unchecked_field 'is_admin'
    end

    scenario 'click create button with uncorrent value' do
      fill_in :email, with: '  '
      check :is_admin

      expect do
        click_button '登録'
        wait_for_ajax
      end.not_to change(User, :count)

      is_expected.to have_field 'email', with: '  '
      is_expected.to have_checked_field 'is_admin'
    end
  end
end