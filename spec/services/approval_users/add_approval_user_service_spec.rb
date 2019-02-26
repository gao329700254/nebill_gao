require 'rails_helper'

RSpec.describe ApprovalUsers::AddApprovalUserService do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }

  describe '#execute' do

    let(:approval) { create(:status_of_approval_is_disconfirm, created_user_id: user1.id) }
    let!(:approvla_user) { create(:approval_user, approval: approval, user: user2) }

    before do
      allow(ApprovalMailer).to receive_message_chain(:assignment_user, :deliver_now).and_return(true)
      chatwork_approval = instance_double(Chatwork::Approval, notify_assigned: true)
      allow(Chatwork::Approval).to receive(:new).and_return(chatwork_approval)
    end

    subject { ApprovalUsers::AddApprovalUserService.new(create_params: create_params, current_user: current_user).execute }

    context 'when inputting correctly' do
      let(:create_params) do
        {
          approval_id: approval.id,
          user: {
            id:        user3.id,
          },
        }
      end

      let(:current_user) { user1 }

      it do
        is_expected.to be_truthy
        prv_approval = Approval.find(approval.id)
        prv_user = prv_approval.users.second

        expect(prv_approval.users.count).to eq(2)
        expect(prv_user).to eq(user3)
      end
    end

    context 'when not set user' do
      let(:create_params) do
        {
          approval_id: approval.id,
          user: {
            id:        nil,
          },
        }
      end

      let(:current_user) { user1 }

      it { is_expected.to be_falsey }
    end
  end
end
