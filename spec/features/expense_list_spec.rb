require 'rails_helper'

RSpec.feature 'Expenxe List Page', js: true do
  given!(:user)    { create(:user) }
  given!(:expense1)    { create(:expense) }

  background { login user, with_capybara: true }
  background { visit expense_list_path }
  background { expense1.update_attributes(created_user_id: user.id) }

  subject { page }

  context 'expense new modal' do
    background { click_button '経費新規作成' }
    subject    { find('.expense_new') }

    scenario 'show' do
      is_expected.to have_css    '.expense_new__outer'
      is_expected.to have_field  'use_date'
      is_expected.to have_select('費目')
      is_expected.to have_field  'amount'
      is_expected.to have_select('支払種別')
      is_expected.to have_select('プロジェクト')
      is_expected.to have_field  'notes'
      is_expected.to have_button '登録'
      is_expected.to have_button '続けて入力'
      is_expected.to have_button 'キャンセル'
      is_expected.to have_button '履歴から読み込み'
    end

    context 'expense history modal' do
      background { click_button '履歴から読み込み' }
      subject    { find('.expense_history') }

      scenario 'show' do
        is_expected.to have_css    '.expense_history__outer'
        is_expected.to have_select 'default_id'
        is_expected.to have_field  'station'
        is_expected.to have_field  'note'
        is_expected.to have_button '検索'
        is_expected.to have_css    '.expense_list__tbl'
        is_expected.to have_button '読み込み'
      end
    end

    scenario 'create expense by using history with submit' do
      click_button '履歴から読み込み'
      expect(page).to have_css    '.expense_history__outer'
      expect(find('.expense_history')).to have_content expense1.use_date
      expect(find('.expense_history')).to have_content expense1.amount.to_s(:delimited)
      expect(find('.expense_history')).to have_content expense1.notes
      expect(find('.expense_history')).to have_content expense1.default.name
      expect(find('.expense_history')).to have_content expense1.project

      within '.expense_history' do
        find("#expense-#{expense1.id}").click
      end

      click_button '読み込み'
      expect(page).not_to have_css    '.expense_history__outer'

      expect do
        click_button '登録'
        wait_for_ajax
      end.to change(Expense, :count).by(1)

      expense2 = Expense.where(created_user_id: user.id).last

      expect(expense2.use_date).to eq expense1.use_date
      expect(expense2.amount).to eq expense1.amount
      expect(expense2.notes).to eq expense1.notes
      expect(expense2.default.name).to eq expense1.default.name
      expect(expense2.project).to eq expense1.project
      expect(page).not_to have_css    '.expense_new__outer'
    end

    scenario 'create expense by using history with repeat' do
      click_button '履歴から読み込み'
      expect(page).to have_css    '.expense_history__outer'
      expect(find('.expense_history')).to have_content expense1.use_date
      expect(find('.expense_history')).to have_content expense1.amount.to_s(:delimited)
      expect(find('.expense_history')).to have_content expense1.notes
      expect(find('.expense_history')).to have_content expense1.default.name
      expect(find('.expense_history')).to have_content expense1.project

      within '.expense_history' do
        find("#expense-#{expense1.id}").click
      end

      click_button '読み込み'
      expect(page).not_to have_css    '.expense_history__outer'

      expect do
        click_button '続けて入力'
        wait_for_ajax
      end.to change(Expense, :count).by(1)

      expense2 = Expense.where(created_user_id: user.id).last

      expect(expense2.use_date).to eq expense1.use_date
      expect(expense2.amount).to eq expense1.amount
      expect(expense2.notes).to eq expense1.notes
      expect(expense2.default.name).to eq expense1.default.name
      expect(expense2.project).to eq expense1.project
      expect(page).to have_css    '.expense_new__outer'
    end
  end
end
