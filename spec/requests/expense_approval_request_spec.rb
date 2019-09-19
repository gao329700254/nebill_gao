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
    subject do
      patch path, params: params
      expense_approval.reload
    end

    context 'updated disconfirm application by applicant' do
      let(:applicant)              { create(:user) }
      let(:approver)               { create(:user) }
      let(:admin_user)             { create(:admin_user) }
      let!(:expense_approval)      { create(:expense_approval, created_user: applicant, status: "permission") }
      let!(:expense_approval_user) { create(:expense_approval_user, user: approver, expense_approval: expense_approval) }
      let(:cw_instance)            { Chatwork::ExpenseApproval.new }
      let(:path)                   { "/api/expense_approvals/#{expense_approval.id}" }
      let(:params) do
        {
          id:     expense_approval.id,
          button: 'disconfirm',
          expense_approval_user: { comment: "" },
        }
      end

      it 'applicant cannot disconfirm "permission" expense approval' do
        login(applicant)
        expect { subject }.to raise_error(NoMethodError)
        expect(expense_approval.status).to eq 'permission'
      end

      it 'admin user cannot disconfirm "permission" expense approval' do
        login(admin_user)
        expect { subject }.to raise_error(NoMethodError)
        expect(expense_approval.status).to eq 'permission'
      end
    end

    context 'updated disconfirm application by approver' do
      let(:applicant)              { create(:user) }
      let(:approver)               { create(:user) }
      let!(:expense_approval)      { create(:expense_approval, created_user: applicant, status: "permission") }
      let!(:expense_approval_user) { create(:expense_approval_user, user: approver, expense_approval: expense_approval) }
      let(:mailer)                 { ExpenseApprovalMailer.disconfirm_expense_approval }
      let(:cw_instance)            { Chatwork::ExpenseApproval.new }
      let(:path)                   { "/api/expense_approvals/#{expense_approval.id}" }
      let(:params) do
        {
          id:     expense_approval.id,
          button: 'disconfirm',
          expense_approval_user: { comment: "" },
        }
      end

      before do
        allow(ExpenseApprovalMailer).to receive(:disconfirm_expense_approval).and_return(mailer)
        allow(ExpenseApprovalMailer.disconfirm_expense_approval).to receive(:deliver_now).and_return(true)
        allow(Chatwork::ExpenseApproval.new).to receive(:expense_approval).and_return(:cw_instance)
        allow(cw_instance).to receive(:notify_disconfirm).and_return(true)
        login(approver)
      end

      it ' can disconfirm "permission" expense approval' do
        subject
        expect(expense_approval.status).to eq 'disconfirm'
      end
    end
  end
end
