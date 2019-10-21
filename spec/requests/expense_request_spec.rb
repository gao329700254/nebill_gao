require 'rails_helper'

RSpec.describe Expense, type: :request do
  describe 'POST /api/expenses/reapproval.json' do
    context 'reapply disconfirm application by applicant' do
      let(:applicant)              { create(:user) }
      let(:approver)               { create(:user) }
      let(:expense)                { create(:expense, expense_approval: expense_approval) }
      let(:expense_approval)       { create(:expense_approval, created_user: applicant, status: "disconfirm") }
      let!(:expense_approval_user) { create(:expense_approval_user, user: approver, expense_approval: expense_approval) }
      let(:mailer)                 { ExpenseApprovalMailer.disconfirm_expense_approval }
      let(:cw_instance)            { Chatwork::ExpenseApproval.new }
      let(:path)                   { '/api/expenses/reapproval' }
      let(:params)                 { { selectedApproval: expense_approval.id } }

      before do
        allow(ExpenseApprovalMailer).to receive(:update_expense_approval).and_return(mailer)
        allow(ExpenseApprovalMailer.update_expense_approval).to receive(:deliver_now).and_return(true)
        allow(Chatwork::ExpenseApproval.new).to receive(:expense_approval).and_return(:cw_instance)
        allow(cw_instance).to receive(:notify_disconfirm).and_return(true)
        login(applicant)
        post path, params: params
      end

      it 'can reapply "disconfirm" expense approval' do
        expect(expense_approval.reload.status).to eq "pending"
      end
    end
  end

  describe 'POST /api/expenses/employee_load_projects.json' do
    before do
      login(user)
    end

    let!(:project)  { create(:project) }
    let(:path)      { '/api/expenses/employee_load_projects' }
    let(:user)      { create(:user) }
    let(:user2)     { create(:user) }

    context 'response project is equal project of login_user' do
      let!(:member) { create(:member, project_id: project.id, employee_id: user.employee.id, type: 'User') }
      it do
        post path
        body = JSON.parse(response.body)
        expect(body.first['cd']).to eq project.cd
      end
    end

    context 'response project is no project' do
      let!(:member)                 { create(:member, project_id: project.id, employee_id: user2.employee.id, type: 'User') }
      it do
        post path
        body = JSON.parse(response.body)
        expect(body).to eq []
      end
    end
  end
end
