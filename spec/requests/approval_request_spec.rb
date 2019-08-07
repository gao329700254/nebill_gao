require 'rails_helper'

RSpec.describe Approval, type: :request do
  let(:user) { create(:user) }
  before { login(user) }

  describe 'POST /api/approvals/:approval_id/invalid' do
    let(:path) { "/api/approvals/#{approval.id}/invalid" }
    let(:params) { { approval_id: approval.id } }
    subject { approval.reload }

    context 'approval in user approval' do
      let(:approval) { create(:approval, :user_approval, created_user: user) }
      before { post path, params: params }

      it 'changes approval.status to "invalid"' do
        expect(subject.status).to eq 'invalid'
      end
      it 'changes statuses of all approval_users to invalid' do
        expect(subject.approval_users.size).not_to eq 0
        expect(subject.approval_users.all? { |approval_user| approval_user.status == :invalid }).to eq true
      end
    end

    context 'approval in group approval' do
      let(:approval) { create(:approval, :group_approval, created_user: user) }
      before { post path, params: params }

      it 'changes approval.status to "invalid"' do
        expect(subject.status).to eq 'invalid'
      end
      it 'changes statuses of all approval_users to invalid' do
        expect(subject.approval_users.size).not_to eq 0
        expect(subject.approval_users.all? { |approval_user| approval_user.status == :invalid }).to eq true
      end
    end
  end
end
