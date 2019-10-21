require 'rails_helper'

RSpec.describe ApprovalUsers::UpdateStatusService do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }

  describe '#execute' do

    let(:approval) { create(:approval, created_user_id: user1.id) }
    let!(:approvla_user) { create(:approval_user, approval: approval, user: user2) }

    subject { ApprovalUsers::UpdateStatusService.new(update_params: update_params, current_user: current_user).execute }

    context 'when inputting correctly(permission)' do
      let(:update_params) do
        {
          approval_id: approval.id,
          button: 'permission',
          comment: '',
        }
      end

      let(:current_user) { user2 }

      it do
        is_expected.to be_truthy
        prv_approval = Approval.find(approval.id)
        prv_user = prv_approval.approval_users.first

        expect(prv_approval.status).to eq(20)
        expect(prv_user.status).to eq(20)
      end

      context 'when oneuser inputting correctly(permission)' do
        let(:user4) { create(:user) }
        let!(:approvla_user2) { create(:approval_user, approval: approval, user: user4) }

        it do
          is_expected.to be_truthy
          prv_approval = Approval.find(approval.id)
          prv_user = prv_approval.approval_users.first

          expect(prv_approval.status).to eq(10)
          expect(prv_user.status).to eq(20)
        end
      end
    end

    context 'when inputting correctly(disconfirm)' do
      let(:update_params) do
        {
          approval_id: approval.id,
          button: 'disconfirm',
          comment: '',
        }
      end

      let(:current_user) { user2 }

      it do
        is_expected.to be_truthy
        prv_approval = Approval.find(approval.id)
        prv_user = prv_approval.approval_users.first

        expect(prv_approval.status).to eq(30)
        expect(prv_user.status).to eq(30)
      end

      context 'when oneuser inputting correctly(disconfirm)' do
        let(:user4) { create(:user) }
        let!(:approvla_user2) { create(:approval_user, approval: approval, user: user4) }

        it do
          is_expected.to be_truthy
          prv_approval = Approval.find(approval.id)
          prv_user = prv_approval.approval_users.first

          expect(prv_approval.status).to eq(30)
          expect(prv_user.status).to eq(30)
        end
      end
    end
    context 'when long comment' do
      let(:update_params) do
        {
          approval_id: approval.id,
          button: 'disconfirm',
          comment: ('ア' * 201),
        }
      end

      let(:current_user) { user2 }

      it { is_expected.to be_falsey }
    end

    context 'when long comment' do
      let(:update_params) do
        {
          approval_id: approval.id,
          button: 'permission',
          comment: ('ア' * 201),
        }
      end

      let(:current_user) { user2 }

      it { is_expected.to be_falsey }
    end
  end
end
