require 'rails_helper'

RSpec.feature 'Partners Page', js: true do
  given!(:user) { create(:user) }
  given!(:partner1) { create(:partner, company_name: 'hoge') }
  given!(:partner2) { create(:partner, company_name: 'hoge') }
  given!(:partner3) { create(:partner, company_name: 'huga') }

  background { login user, with_capybara: true }
  background do
    visit partners_path
    wait_for_ajax
  end

  subject { page }

  scenario 'show' do
    is_expected.to have_header_title 'パートナー一覧'

    is_expected.to have_content '会社名'
    is_expected.to have_content 'ID'
    is_expected.to have_content '名前'
    is_expected.to have_content 'メールアドレス'

    expect(all('.partners__partner_company_list__tbl__body__row td:nth-child(1)')[0]).to     have_content partner1.company_name
    expect(all('.partners__partner_company_list__tbl__body__row td:nth-child(1)')[1]).not_to have_content partner2.company_name
    expect(all('.partners__partner_company_list__tbl__body__row td:nth-child(1)')[1]).to     have_content partner3.company_name
  end

  scenario 'click company name' do
    page.all('.partners__partner_company_list__tbl__body__row td:nth-child(1)')[0].click
    sleep Capybara.default_max_wait_time
    expect(all('.partners__partner_list__tbl__body__row td:nth-child(1)')[0]).to have_content partner1.cd
    expect(all('.partners__partner_list__tbl__body__row td:nth-child(2)')[0]).to have_content partner1.name
    expect(all('.partners__partner_list__tbl__body__row td:nth-child(3)')[0]).to have_content partner1.email
    expect(all('.partners__partner_list__tbl__body__row td:nth-child(1)')[1]).to have_content partner2.cd
    expect(all('.partners__partner_list__tbl__body__row td:nth-child(2)')[1]).to have_content partner2.name
    expect(all('.partners__partner_list__tbl__body__row td:nth-child(3)')[1]).to have_content partner2.email
    is_expected.not_to have_content partner3.name
    is_expected.not_to have_content partner3.email
  end
end
