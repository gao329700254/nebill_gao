require 'rails_helper'

RSpec.describe ExpenseApproval, type: :request do
  let(:user) { create(:user) }
  before { login(user) }

  describe 'PATCH /api/expense_approvals/:id' do
    subject { expense_approval.reload }

    context 'params[:button] == "invalid"' do
      let(:expense_approval) { create(:expense_approval, created_user: user) }
      let(:path) { "/api/expense_approvals/#{expense_approval.id}" }
      let(:params) do
        {
          id: expense_approval.id,
          button: 'invalid',
        }
      end

      before { patch path, params }

      it 'changes expense_approval.status to "invalid"' do
        expect(subject.status).to eq 'invalid'
      end
      it 'changes statuses of all expense_approval_users to invalid' do
        expect(subject.expense_approval_user.size).not_to eq 0
        expect(subject.expense_approval_user.all? { |approval_user| approval_user.status == :invalid }).to eq true
      end
    end
  end
end
