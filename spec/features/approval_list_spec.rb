require 'rails_helper'

RSpec.feature 'Approval List Page', js: true do
  given!(:user)    { create(:user) }
  given!(:per)     { 20 }
  background do
    login user, with_capybara: true
    create_list(:approval, per, :user_approval, created_user_id: user.id)
    visit approval_list_path
  end

  subject { page }

  context "with less than per records" do
    scenario "does not paginate records" do
      is_expected.not_to have_css '.pagination'
      is_expected.to have_no_xpath("//*[@class='pagination']//a[text()='2']")
      expect(all('.approval_list__tbl__body__row').size).to eq(20)
    end
  end

  context "with over per records" do
    background { create(:approval, :user_approval, created_user_id: user.id) }

    scenario "paginates records" do
      visit current_path
      is_expected.to have_css '.pagination'
      is_expected.to have_xpath("//*[@class='pagination']//a[text()='2']")
      find(:xpath, "//*[@class='pagination']//a[text()='2']").click
      expect(page.status_code).to eq(200)
    end
  end
end
