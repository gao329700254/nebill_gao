require 'rails_helper'

RSpec.feature 'Client New Page', js: true do
  given!(:user) { create(:user) }

  background { login user, with_capybara: true }
  background { visit client_new_path }

  subject { page }

  scenario 'show' do
    is_expected.to have_header_title '顧客新規作成'
  end

  describe 'form' do
    subject { find('#client_new .client_new__form') }

    scenario 'show' do
      is_expected.to have_field 'key'
      is_expected.to have_field 'company_name'
      is_expected.to have_field 'department_name'
      is_expected.to have_field 'address'
      is_expected.to have_field 'zip_code'
      is_expected.to have_field 'phone_number'
      is_expected.to have_field 'memo'
      is_expected.to have_button '登録'
    end

    scenario 'click submit button with correct values' do
      fill_in :key        , with: '0000001'
      fill_in :company_name    , with: 'test company'
      fill_in :department_name , with: 'test department'
      fill_in :address         , with: 'test address'
      fill_in :zip_code        , with: '1234567'
      fill_in :phone_number    , with: '1234-5678'
      fill_in :memo            , with: 'test memo'

      expect do
        click_button '登録'
        wait_for_ajax
      end.to change(Client, :count).by(1)

      is_expected.to have_field 'key'               , with: ''
      is_expected.to have_field 'company_name'      , with: ''
      is_expected.to have_field 'department_name'   , with: ''
      is_expected.to have_field 'address'           , with: ''
      is_expected.to have_field 'zip_code'          , with: ''
      is_expected.to have_field 'phone_number'      , with: ''
      is_expected.to have_field 'memo'              , with: ''
    end

    scenario 'click submit button with uncorrect values' do
      fill_in :key        , with: '  '
      fill_in :company_name    , with: 'test company'
      fill_in :department_name , with: 'test department'
      fill_in :address         , with: 'test address'
      fill_in :zip_code        , with: '1234567'
      fill_in :phone_number    , with: '1234-5678'
      fill_in :memo            , with: 'test memo'

      expect do
        click_button '登録'
        wait_for_ajax
      end.not_to change(Client, :count)

      is_expected.to have_field 'key'               , with: '  '
      is_expected.to have_field 'company_name'      , with: 'test company'
      is_expected.to have_field 'department_name'   , with: 'test department'
      is_expected.to have_field 'address'           , with: 'test address'
      is_expected.to have_field 'zip_code'          , with: '1234567'
      is_expected.to have_field 'phone_number'      , with: '1234-5678'
      is_expected.to have_field 'memo'              , with: 'test memo'
    end
  end
end
