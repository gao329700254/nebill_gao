require 'rails_helper'

RSpec.describe ExpenseApproval, type: :model do

  describe '#search_expense_approval' do
    subject { ExpenseApproval.search_expense_approval(current_user: current_user, search_created_at: search_created_at) }

    describe 'with role is general' do
      let(:current_user) { create(:user) }
      let(:search_created_at) { nil }
      context 'with a approval I made' do
        let(:expense_approval) { create(:expense_approval, created_user: current_user) }
        it do
          is_expected.to eq [expense_approval]
        end
      end

      context 'with approver' do
        let(:another_user) { create(:user) }
        let(:expense_approval) { create(:expense_approval, created_user: another_user) }
        let!(:expense_approval_user) { create(:expense_approval_user, expense_approval: expense_approval, user: current_user) }
        it do
          is_expected.to eq [expense_approval]
        end
      end
    end

    describe 'with role is admin' do
      let(:current_user) { create(:admin_user) }
      let(:another_user) { create(:user) }
      let(:search_created_at) { nil }
      context 'with a approval I made' do
        let(:expense_approval) { create(:expense_approval, created_user: current_user) }
        let(:expense_approval2) { create(:expense_approval, created_user: another_user) }
        it do
          is_expected.to eq [expense_approval, expense_approval2]
        end
      end

      context 'with approver' do
        let(:expense_approval) { create(:expense_approval, created_user: another_user) }
        let(:expense_approval2) { create(:expense_approval, created_user: another_user) }
        let!(:expense_approval_user) { create(:expense_approval_user, expense_approval: expense_approval, user: current_user) }
        it do
          is_expected.to eq [expense_approval, expense_approval2]
        end
      end
    end
  end
end
