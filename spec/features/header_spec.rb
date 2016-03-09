require 'rails_helper'

RSpec.feature 'Header', js: true do

  subject { page.find('#header') }

  context 'when not logged in' do
    background { visit root_path }

    scenario 'show' do
      is_expected.to     have_content 'ログイン'
      is_expected.not_to have_content 'ログアウト'
    end
  end

  context 'when not logged in' do
    given!(:user) { create(:user) }

    background { login user, with_capybara: true }
    background { visit root_path }

    scenario 'show' do
      is_expected.to     have_content user.name
      is_expected.not_to have_content 'ログイン'
      is_expected.to     have_content 'ログアウト'
    end
  end

end
