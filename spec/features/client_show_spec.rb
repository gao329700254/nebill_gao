require 'rails_helper'

RSpec.feature 'Client Show Page', js: true, versioning: true do
  given!(:user)     { create(:admin_user) }
  given!(:client)   { create(:client) }
  given!(:approval) { create(:approval, :user_approval, created_user: user, approved: client) }

  background { login user, with_capybara: true }
  background { visit client_show_path(client) }

  subject { page }

  scenario 'show' do
    is_expected.to have_header_title '取引先情報'
    is_expected.to have_content '最終更新日時: ' + I18n.l(client.updated_at.in_time_zone('Tokyo'))
  end

  describe 'form' do
    subject { find('.client_show__form') }

    scenario 'should show client attributes' do
      is_expected.to have_field         'cd'             , disabled: true, with: client.cd
      is_expected.to have_field         'company_name'   , disabled: true, with: client.company_name
      is_expected.to have_field         'department_name', disabled: true, with: client.department_name
      is_expected.to have_field         'address'        , disabled: true, with: client.address
      is_expected.to have_field         'zip_code'       , disabled: true, with: client.zip_code
      is_expected.to have_field         'phone_number'   , disabled: true, with: client.phone_number
      is_expected.to have_field         'memo'           , disabled: true, with: client.memo
      is_expected.to have_checked_field 'is_valid'       , disabled: true
      is_expected.to have_button        '編集'
      is_expected.not_to have_button    'キャンセル'
      is_expected.not_to have_button    '更新'
    end

    context 'when click edit button' do
      background { click_button '編集' }

      scenario 'should have edit client fields' do
        is_expected.to     have_field         'cd'             , disabled: false, with: client.cd
        is_expected.to     have_field         'company_name'   , disabled: false, with: client.company_name
        is_expected.to     have_field         'department_name', disabled: false, with: client.department_name
        is_expected.to     have_field         'address'        , disabled: false, with: client.address
        is_expected.to     have_field         'zip_code'       , disabled: false, with: client.zip_code
        is_expected.to     have_field         'phone_number'   , disabled: false, with: client.phone_number
        is_expected.to     have_field         'memo'           , disabled: false, with: client.memo
        is_expected.to     have_checked_field 'is_valid'       , disabled: false
        is_expected.not_to have_button        '編集'
        is_expected.to     have_button        'キャンセル'
        is_expected.to     have_button        '更新'
      end

      scenario 'should not update when click cancel button' do
        original_cd              = client.cd
        original_company_name    = client.company_name
        original_department_name = client.department_name
        original_address         = client.address
        original_zip_code        = client.zip_code
        original_phone_number    = client.phone_number
        original_memo            = client.memo

        fill_in :cd              , with: '0000001'
        fill_in :company_name    , with: 'company_name'
        fill_in :department_name , with: 'department_name'
        fill_in :address         , with: 'address'
        fill_in :zip_code        , with: '123-4567'
        fill_in :phone_number    , with: '03-1234-5678'
        fill_in :memo            , with: 'memo'
        uncheck :is_valid

        expect do
          click_button 'キャンセル'
          wait_for_ajax
        end.not_to change { client.reload && client.updated_at }

        is_expected.to have_field         'cd'             , disabled: true, with: original_cd
        is_expected.to have_field         'company_name'   , disabled: true, with: original_company_name
        is_expected.to have_field         'department_name', disabled: true, with: original_department_name
        is_expected.to have_field         'address'        , disabled: true, with: original_address
        is_expected.to have_field         'zip_code'       , disabled: true, with: original_zip_code
        is_expected.to have_field         'phone_number'   , disabled: true, with: original_phone_number
        is_expected.to have_field         'memo'           , disabled: true, with: original_memo
        is_expected.to have_checked_field 'is_valid'       , disabled: true
      end

      scenario 'should update when click submit button with correct values' do
        fill_in :cd              , with: 'cd-1'
        fill_in :company_name    , with: 'company_name'
        fill_in :department_name , with: 'department_name'
        fill_in :address         , with: 'address'
        fill_in :zip_code        , with: '123-4567'
        fill_in :phone_number    , with: '03-1234-5678'
        fill_in :memo            , with: 'memo'
        uncheck :is_valid

        expect do
          click_button '更新'
          wait_for_ajax
        end.to change { client.reload && client.updated_at }

        is_expected.to have_field           'cd'             , disabled: true, with: 'CD-1'
        is_expected.to have_field           'company_name'   , disabled: true, with: 'company_name'
        is_expected.to have_field           'department_name', disabled: true, with: 'department_name'
        is_expected.to have_field           'address'        , disabled: true, with: 'address'
        is_expected.to have_field           'zip_code'       , disabled: true, with: '123-4567'
        is_expected.to have_field           'phone_number'   , disabled: true, with: '03-1234-5678'
        is_expected.to have_field           'memo'           , disabled: true, with: 'memo'
        is_expected.to have_unchecked_field 'is_valid'       , disabled: true
      end

      scenario 'should not update when click submit button with uncorrect values' do
        fill_in :cd              , with: 'cd-1'
        fill_in :company_name    , with: '  '
        fill_in :department_name , with: 'department_name'
        fill_in :address         , with: 'address'
        fill_in :zip_code        , with: '123-4567'
        fill_in :phone_number    , with: '03-1234-5678'
        fill_in :memo            , with: 'memo'
        uncheck :is_valid

        expect do
          click_button '更新'
          wait_for_ajax
        end.not_to change { client.reload && client.updated_at }

        is_expected.to have_field           'cd'              , disabled: false, with: 'cd-1'
        is_expected.to have_field           'company_name'    , disabled: false, with: '  '
        is_expected.to have_field           'department_name' , disabled: false, with: 'department_name'
        is_expected.to have_field           'address'         , disabled: false, with: 'address'
        is_expected.to have_field           'zip_code'        , disabled: false, with: '123-4567'
        is_expected.to have_field           'phone_number'    , disabled: false, with: '03-1234-5678'
        is_expected.to have_field           'memo'            , disabled: false, with: 'memo'
        is_expected.to have_unchecked_field 'is_valid'        , disabled: false
      end
    end
  end
end
