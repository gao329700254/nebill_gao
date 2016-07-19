require 'rails_helper'

RSpec.feature 'Header', js: true do
  given!(:user) { create(:user) }

  background { login user, with_capybara: true }
  background { visit project_list_path }

  subject { page.find('#header') }

  scenario 'show' do
    is_expected.to     have_content user.name
    is_expected.not_to have_content 'ログイン'
    is_expected.to     have_content 'ログアウト'
  end

end
