require 'rails_helper'

RSpec.feature 'Client List Page', js: true do
  given!(:user)    { create(:user) }
  given!(:client1) { create(:client,         :published, cd: 'CD-1', company_name: 'abc', department_name: 'ABC', phone_number: '03-1111-1111', user: user) }
  given!(:client2) { create(:client,         :published, cd: 'CD-2', company_name: 'cde', department_name: 'CDE', phone_number: '03-2222-2222', user: user) }
  given!(:client3) { create(:client,         :published, cd: 'CD-3', company_name: 'fgh', department_name: 'FGH', phone_number: '03-3333-3333', user: user) }
  given!(:client4) { create(:invalid_client, :published, cd: 'CD-4', company_name: 'ijk', department_name: 'IJK', phone_number: '03-4444-4444', user: user) }

  background { login user, with_capybara: true }
  background { visit client_list_path }

  subject { page }

  scenario 'show' do
    is_expected.to have_header_title '取引先一覧'

    is_expected.to have_field           'search', with: ''
    is_expected.to have_unchecked_field 'is_valid'
    is_expected.to have_button          '取引先新規作成'

    is_expected.to have_content 'ID'
    is_expected.to have_content '会社名'
    is_expected.to have_content '部署名'
    is_expected.to have_content '承認ステータス'
    is_expected.to have_content '電話番号'

    is_expected.to have_content client1.cd
    is_expected.to have_content client1.company_name
    is_expected.to have_content client1.department_name
    is_expected.to have_content client1.phone_number

    is_expected.to have_content client2.cd
    is_expected.to have_content client3.cd

    expect(all('.client_list__tbl__body__row td:first-child')[0]).to     have_text client1.cd
    expect(all('.client_list__tbl__body__row td:first-child')[1]).to     have_text client2.cd
    expect(all('.client_list__tbl__body__row td:first-child')[2]).to     have_text client3.cd
    expect(all('.client_list__tbl__body__row td:first-child')[3]).not_to have_text client4.cd
  end

  context 'search' do
    scenario 'with blank' do
      fill_in :search, with: ''
      is_expected.to have_content     client1.cd
      is_expected.to have_content     client2.cd
      is_expected.to have_content     client3.cd
      is_expected.not_to have_content client4.cd
    end

    scenario 'with just a cd' do
      fill_in :search, with: 'CD-1'
      is_expected.to     have_content client1.cd
      is_expected.not_to have_content client2.cd
      is_expected.not_to have_content client3.cd
      is_expected.not_to have_content client4.cd
    end

    scenario 'with a part of company name' do
      fill_in :search, with: 'bc'
      is_expected.to     have_content client1.cd
      is_expected.not_to have_content client2.cd
      is_expected.not_to have_content client3.cd
      is_expected.not_to have_content client4.cd
    end

    scenario 'with a part of department name' do
      fill_in :search, with: 'bc'
      is_expected.to     have_content client1.cd
      is_expected.not_to have_content client2.cd
      is_expected.not_to have_content client3.cd
      is_expected.not_to have_content client4.cd
    end

    scenario 'with just a phone number' do
      fill_in :search, with: '03-1111-1111'
      is_expected.to     have_content client1.cd
      is_expected.not_to have_content client2.cd
      is_expected.not_to have_content client3.cd
      is_expected.not_to have_content client4.cd
    end

    scenario 'with multiple keywords' do
      fill_in :search, with: 'CD-2 cde'
      is_expected.not_to have_content client1.cd
      is_expected.to     have_content client2.cd
      is_expected.not_to have_content client3.cd
      is_expected.not_to have_content client4.cd
    end
  end

  scenario 'link to a client show page when click row' do
    find("#client-#{client1.id}").click

    is_expected.to have_header_title '取引先情報'
  end

  scenario 'show Client New Modal when click show modal button' do
    is_expected.not_to have_css '.client_new__outer'

    click_on '取引先新規作成'
    is_expected.to     have_css '.client_new__outer'
  end

  context 'Client New Modal' do
    background { click_button '取引先新規作成' }
    subject    { find('.client_new') }

    scenario 'show' do
      is_expected.to have_field  'company_name'
      is_expected.to have_field  'department_name'
      is_expected.to have_field  'address'
      is_expected.to have_field  'zip_code'
      is_expected.to have_field  'phone_number'
      is_expected.to have_field  'memo'
      is_expected.to have_button '登録'
      is_expected.to have_button 'キャンセル'
    end

    scenario 'click submit button with correct values' do
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

      is_expected.not_to have_css 'client_new__outer'
    end

    scenario 'click submit button with uncorrect values' do
      fill_in :company_name    , with: '  '
      fill_in :department_name , with: 'test department'
      fill_in :address         , with: 'test address'
      fill_in :zip_code        , with: '1234567'
      fill_in :phone_number    , with: '1234-5678'
      fill_in :memo            , with: 'test memo'

      expect do
        click_button '登録'
        wait_for_ajax
      end.not_to change(Client, :count)

      is_expected.to have_field 'company_name'      , with: '  '
      is_expected.to have_field 'department_name'   , with: 'test department'
      is_expected.to have_field 'address'           , with: 'test address'
      is_expected.to have_field 'zip_code'          , with: '1234567'
      is_expected.to have_field 'phone_number'      , with: '1234-5678'
      is_expected.to have_field 'memo'              , with: 'test memo'
    end

    scenario 'click cancel' do
      is_expected.to     have_css '.client_new__outer'

      click_button 'キャンセル'
      is_expected.not_to have_css '.client_new__outer'
    end
  end

  scenario 'show invalid clients when checkbox is checked' do
    check 'is_valid'

    is_expected.to     have_content client4.cd
    is_expected.to     have_content client4.company_name
    is_expected.to     have_content client4.department_name
    is_expected.to     have_content client4.phone_number

    is_expected.not_to have_content client1.cd
    is_expected.not_to have_content client2.cd
    is_expected.not_to have_content client3.cd
  end
end
