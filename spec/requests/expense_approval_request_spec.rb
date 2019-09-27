require 'rails_helper'

RSpec.describe ExpenseApproval, type: :request do
  describe 'PATCH /api/expense_approvals/:id' do
    subject { expense_approval.reload }

    let(:user) { create(:user) }
    before     { login(user) }

    context 'params[:button] == "invalid"' do
      let(:expense_approval) { create(:expense_approval, created_user: user) }
      let(:path) { "/api/expense_approvals/#{expense_approval.id}" }
      let(:params) do
        {
          id: expense_approval.id,
          button: 'invalid',
        }
      end

      before { patch path, params: params }

      it 'changes expense_approval.status to "invalid"' do
        expect(subject.status).to eq 'invalid'
      end
      it 'changes statuses of all expense_approval_users to invalid' do
        expect(subject.expense_approval_user.size).not_to eq 0
        expect(subject.expense_approval_user.all? { |approval_user| approval_user.status == :invalid }).to eq true
      end
    end
  end

  describe 'PATCH /api/expense_approvals/:id' do
    subject { patch path, params: params }

    let(:applicant)        { create(:user) }
    let(:admin_user)       { create(:admin_user) }
    let(:expense_approval) { create(:expense_approval, created_user: applicant, status: "permission") }
    let(:path)             { "/api/expense_approvals/#{expense_approval.id}" }
    let(:params) do
      {
        id:     expense_approval.id,
        button: 'disconfirm',
        expense_approval_user: { comment: '' },
      }
    end

    example 'applicant cannot disconfirm "permission" expense approval' do
      login(applicant)
      expect { subject }.to raise_error(NoMethodError)
      expect(expense_approval.reload.status).to eq 'permission'
    end

    example 'admin user cannot disconfirm "permission" expense approval' do
      login(admin_user)
      expect { subject }.to raise_error(NoMethodError)
      expect(expense_approval.reload.status).to eq 'permission'
    end

    context 'current user is approver' do
      let(:approver)               { create(:user) }
      let!(:expense_approval_user) { create(:expense_approval_user, user: approver, expense_approval: expense_approval) }
      let(:mailer)                 { ExpenseApprovalMailer.disconfirm_expense_approval }
      let(:cw_instance)            { Chatwork::ExpenseApproval.new }

      before do
        allow(ExpenseApprovalMailer).to receive(:disconfirm_expense_approval).and_return(mailer)
        allow(ExpenseApprovalMailer.disconfirm_expense_approval).to receive(:deliver_now).and_return(true)
        allow(Chatwork::ExpenseApproval.new).to receive(:expense_approval).and_return(:cw_instance)
        allow(cw_instance).to receive(:notify_disconfirm).and_return(true)
        login(approver)
      end

      it 'can disconfirm "permission" expense approval' do
        subject
        expect(expense_approval.reload.status).to eq 'disconfirm'
      end
    end
  end
end
