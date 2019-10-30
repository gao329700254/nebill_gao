require 'rails_helper'

RSpec.describe BillApplicantsController, type: :request do
  let(:bill)           { create(:bill) }
  let(:user)           { create(:user) }
  let!(:applicant)     { create(:bill_applicant, user: user, bill: bill) }
  let(:project_member) { create(:user) }
  let!(:chief)         { create(:user, is_chief: true) }

  describe 'POST /bills/bill_applicants' do
    let(:path)   { "/bills/bill_applicants" }
    let(:params) do
      {
        user_id: project_member.id,
        bill_id: bill.id,
        comment: '申請します。',
        commit:  '申請',
      }
    end

    before do
      login(user)
      post path, params: params
    end

    it 'update bill status to "pending"' do
      expect(Bill.find(bill.id).status).to eq 'pending'
    end

    it 'update bill applicant comment' do
      expect(BillApplicant.find_by(bill_id: bill.id).comment).to eq '申請します。'
    end

    it 'create primary approver' do
      expect(BillApprovalUser.count).to eq 1
      expect(BillApprovalUser.first.user_id).to eq project_member.id
      expect(BillApprovalUser.first.status).to eq 'pending'
    end
  end

  describe 'PATCH /bills/bill_applicants/:id' do
    subject { patch path, params: params }

    let!(:primary_approver)   { create(:bill_approval_user, bill: bill, user: project_member, status: 'approved', role: 'primary') }
    let!(:secondary_approver) { create(:bill_approval_user, bill: bill, user: chief, status: 'pending', role: 'secondary') }
    let(:path)   { "/bills/bill_applicants/#{applicant.id}" }
    let(:params) do
      {
        bill_applicant: {
          bill_id: bill.id,
        },
        commit: '取消',
        id:     applicant.id,
      }
    end

    before { login(user) }

    it 'originally primary and secondary approvers are set' do
      expect(BillApprovalUser.where(bill_id: bill.id).count).to eq 2
      expect(BillApprovalUser.find_by(bill_id: bill.id, role: 'primary').user_id).to eq project_member.id
      expect(BillApprovalUser.find_by(bill_id: bill.id, role: 'secondary').user_id).to eq chief.id
    end

    context 'cancenl when bill is "pending" for being approved' do
      before do
        bill.update(status: 'pending')
        subject
      end

      it 'update bill status to cancel' do
        expect(Bill.find(bill.id).status).to eq 'cancelled'
      end

      it 'all approvers are deleted' do
        expect(BillApprovalUser.where(bill_id: bill.id).count).to eq 0
      end
    end

    context 'cancenl when bill is sent back' do
      before do
        bill.update(status: 'sent_back')
        subject
      end

      it 'update bill status to cancel' do
        expect(Bill.find(bill.id).status).to eq 'cancelled'
      end

      it 'all approvers are deleted' do
        expect(BillApprovalUser.where(bill_id: bill.id).count).to eq 0
      end
    end
  end
end
