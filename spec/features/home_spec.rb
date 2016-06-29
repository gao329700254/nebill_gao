require 'rails_helper'

RSpec.feature 'Home', js: true do

  subject { page.find('#home') }

  background { visit root_path }

  scenario 'show' do
    is_expected.to have_content 'シンプルで高機能な請求管理システム'
    is_expected.to have_content 'Nebill'
    is_expected.to have_button 'ログイン'
  end
end
