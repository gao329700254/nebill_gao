require 'rails_helper'

RSpec.feature 'Home', js: true do

  subject { page }

  context 'when not logged in' do

    background { visit root_path }

    scenario 'show' do
      is_expected.to have_content 'シンプルで高機能なプロジェクト管理システム'
      is_expected.to have_content 'Nebill'
      is_expected.to have_button 'ログイン'
    end
  end

  context 'when logged in' do

    given!(:user) { create(:user) }

    background { login user, with_capybara: true }
    background { visit root_path }

    scenario 'show' do
      expect(current_path).to eq project_list_path
    end
  end
end
