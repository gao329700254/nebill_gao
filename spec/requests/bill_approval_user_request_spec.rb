require 'rails_helper'

RSpec.describe 'bill approval users request' do
  let(:project_member) { create(:user) }
  let(:chief)          { create(:user, is_chief: true) }
  let(:bill)           { create(:bill, status: 'pending') }

  describe "POST /api/bills/:bill_id/bill_approval_users" do
    subject { post path, params: params }

    context 'login user is primary approver' do
      let(:primary_approver)    { create(:bill_approval_user, bill: bill, user: project_member, status: 'pending', role: 'primary') }
      let!(:secondary_approver) { create(:bill_approval_user, bill: bill, user: chief, status: 'pending', role: 'secondary') }
      let(:path)                { "/api/bills/#{bill.id}/bill_approval_users" }
      let(:params) do
        {
          user_id: primary_approver.id,
          bill_id: bill.id,
          comment: '',
          commit:  '承認',
        }
      end

      before { login(project_member) }

      it 'do not update bill status' do
        subject
        expect(Bill.find(bill.id).status).to eq 'pending'
      end

      it 'update only primary approver status to approved' do
        subject
        expect(BillApprovalUser.find_by(role: 'primary').status).to eq 'approved'
        expect(BillApprovalUser.find_by(role: 'secondary').status).to eq 'pending'
      end
    end

    context 'login user is secondary approver' do
      let!(:primary_approver)   { create(:bill_approval_user, bill: bill, user: project_member, status: 'approved', role: 'primary') }
      let(:secondary_approver)  { create(:bill_approval_user, bill: bill, user: chief, status: 'pending', role: 'secondary') }
      let(:path)                { "/api/bills/#{bill.id}/bill_approval_users" }
      let(:params) do
        {
          user_id: secondary_approver.id,
          bill_id: bill.id,
          comment: '',
          commit:  '承認',
        }
      end

      before { login(chief) }

      it 'do not update bill status' do
        subject
        expect(Bill.find(bill.id).status).to eq 'approved'
      end

      it 'update only primary approver status to approved' do
        subject
        expect(BillApprovalUser.find_by(role: 'primary').status).to eq 'approved'
        expect(BillApprovalUser.find_by(role: 'secondary').status).to eq 'approved'
      end
    end
  end

  describe "PATCH /api/bill_approval_users/:id" do
    subject { patch path, params: params }

    context 'login user is primary approver' do
      let(:primary_approver)    { create(:bill_approval_user, bill: bill, user: project_member, status: 'pending', role: 'primary') }
      let!(:secondary_approver) { create(:bill_approval_user, bill: bill, user: chief, status: 'pending', role: 'secondary') }
      let(:path)                { "/api/bill_approval_users/#{primary_approver.id}" }
      let(:params) do
        {
          bill_approval_user: {
            bill_id: bill.id,
            comment: '',
          },
          commit: '差戻',
          id:     primary_approver.id,
        }
      end

      before { login(project_member) }

      it 'update bill status to "sent back"' do
        subject
        expect(Bill.find(bill.id).status).to eq 'sent_back'
      end

      it 'update all approvers status to "sent_back"' do
        subject
        expect(BillApprovalUser.find_by(role: 'primary').status).to eq 'sent_back'
        expect(BillApprovalUser.find_by(role: 'secondary').status).to eq 'sent_back'
      end
    end

    context 'login user is secondary approver' do
      let!(:primary_approver)   { create(:bill_approval_user, bill: bill, user: project_member, status: 'pending', role: 'primary') }
      let(:secondary_approver)  { create(:bill_approval_user, bill: bill, user: chief, status: 'pending', role: 'secondary') }
      let(:path)                { "/api/bill_approval_users/#{secondary_approver.id}" }
      let(:params) do
        {
          bill_approval_user: {
            bill_id: bill.id,
            comment: '',
          },
          commit: '差戻',
          id:     secondary_approver.id,
        }
      end

      before { login(chief) }

      it 'update bill status to "sent back"' do
        subject
        expect(Bill.find(bill.id).status).to eq 'sent_back'
      end

      it 'update all approvers status to "sent_back"' do
        subject
        expect(BillApprovalUser.find_by(role: 'primary').status).to eq 'sent_back'
        expect(BillApprovalUser.find_by(role: 'secondary').status).to eq 'sent_back'
      end
    end
  end
end
