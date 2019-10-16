require 'rails_helper'

RSpec.describe 'bill applicants request' do
  let!(:bill)               { create(:bill) }
  let!(:user)               { create(:user) }
  let!(:applicant)          { create(:bill_applicant, user: user, bill: bill) }
  let!(:primary_approver)   { create(:user) }
  let!(:secondary_approver) { create(:user, is_chief: true) }

  before { login(user) }

  describe 'POST /api/bills/:bill_id/bill_applicants' do
    subject { post path, params: params }

    let(:path)   { "/api/bills/#{bill.id}/bill_applicants" }
    let(:params) do
      {
        user_id: primary_approver.id,
        bill_id: bill.id,
        comment: '申請します。',
        commit:  '申請',
      }
    end

    context 'apply bill' do
      it 'update bill status to "pending"' do
        subject
        expect(Bill.find(bill.id).status).to eq 'pending'
      end

      it 'create 2 approval users' do
        subject
        expect(BillApprovalUser.find_by(role: 'primary').user_id).to eq primary_approver.id
        expect(BillApprovalUser.find_by(role: 'primary').status).to eq 'pending'

        expect(BillApprovalUser.find_by(role: 'secondary').user_id).to eq secondary_approver.id
        expect(BillApprovalUser.find_by(role: 'secondary').status).to eq 'pending'
      end
    end
  end

  describe 'PATCH /api/bill_applicants/:id' do
    subject { patch path, params: params }

    let!(:primary_approval_user)   { create(:bill_approval_user, bill: bill, user: primary_approver, status: 'pending', role: 'primary') }
    let!(:secondary_approval_user) { create(:bill_approval_user, bill: bill, user: secondary_approver, status: 'pending', role: 'secondary') }
    let(:path)   { "/api/bill_applicants/#{applicant.id}" }
    let(:params) do
      {
        bill_applicant: {
          bill_id: bill.id,
        },
        commit: '取消',
        id:     applicant.id,
      }
    end

    context 'cancenl when bill is "pending" for primary approver' do
      before { bill.update(status: 'pending') }

      it 'update bill status to cancel' do
        subject
        expect(Bill.find(bill.id).status).to eq 'cancelled'
      end

      it 'all approvers are deleted' do
        subject
        expect(BillApprovalUser.where(bill_id: bill.id).count).to eq 0
      end
    end

    context 'cancenl when bill is sent back' do
      before { bill.update(status: 'sent_back') }

      it 'update bill status to cancel' do
        subject
        expect(Bill.find(bill.id).status).to eq 'cancelled'
      end

      it 'all approvers are deleted' do
        subject
        expect(BillApprovalUser.where(bill_id: bill.id).count).to eq 0
      end
    end
  end
end
