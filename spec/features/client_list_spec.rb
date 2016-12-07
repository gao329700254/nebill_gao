require 'rails_helper'

RSpec.feature 'Client List Page', js: true do
  given!(:user) { create(:user) }
  given!(:client1) { create(:client, cd: 'CD-1', company_name: 'abc', department_name: 'ABC', phone_number: '03-1111-1111') }
  given!(:client2) { create(:client, cd: 'CD-2', company_name: 'cde', department_name: 'CDE', phone_number: '03-2222-2222') }
  given!(:client3) { create(:client, cd: 'CD-3', company_name: 'fgh', department_name: 'FGH', phone_number: '03-3333-3333') }

  background { login user, with_capybara: true }
  background { visit client_list_path }

  subject { page }

  scenario 'show' do
    is_expected.to have_header_title '顧客一覧'

    is_expected.to have_field 'search', with: ''
    is_expected.to have_content 'ID'
    is_expected.to have_content '会社名'
    is_expected.to have_content '部署名'
    is_expected.to have_content '電話番号'

    is_expected.to have_content client1.cd
    is_expected.to have_content client1.company_name
    is_expected.to have_content client1.department_name
    is_expected.to have_content client1.phone_number

    is_expected.to have_content client2.cd
    is_expected.to have_content client3.cd

    expect(all('.client_list__tbl__body__row td:first-child')[0]).to have_text client1.cd
    expect(all('.client_list__tbl__body__row td:first-child')[1]).to have_text client2.cd
    expect(all('.client_list__tbl__body__row td:first-child')[2]).to have_text client3.cd
  end

  context 'search' do
    scenario 'with blank' do
      fill_in :search, with: ''
      is_expected.to have_content client1.cd
      is_expected.to have_content client2.cd
      is_expected.to have_content client3.cd
    end

    scenario 'with just a cd' do
      fill_in :search, with: 'CD-1'
      is_expected.to     have_content client1.cd
      is_expected.not_to have_content client2.cd
      is_expected.not_to have_content client3.cd
    end

    scenario 'with a part of company name' do
      fill_in :search, with: 'bc'
      is_expected.to     have_content client1.cd
      is_expected.not_to have_content client2.cd
      is_expected.not_to have_content client3.cd
    end

    scenario 'with a part of department name' do
      fill_in :search, with: 'bc'
      is_expected.to     have_content client1.cd
      is_expected.not_to have_content client2.cd
      is_expected.not_to have_content client3.cd
    end

    scenario 'with just a phone number' do
      fill_in :search, with: '03-1111-1111'
      is_expected.to     have_content client1.cd
      is_expected.not_to have_content client2.cd
      is_expected.not_to have_content client3.cd
    end

    scenario 'with multiple keywords' do
      fill_in :search, with: 'CD-2 cde'
      is_expected.not_to have_content client1.cd
      is_expected.to     have_content client2.cd
      is_expected.not_to have_content client3.cd
    end
  end

  scenario 'link to a client show page when click row' do
    find("#client-#{client1.id}").click

    is_expected.to have_header_title '顧客情報'
  end

end
