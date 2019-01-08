require 'rails_helper'

RSpec.describe Approvals::UpdateApprovalService do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  let(:uploaded_file) do
    uploaded_file = fixture_file_upload('spec/fixtures/sample.jpg', 'image/jpeg')
    allow(uploaded_file).to receive(:tempfile).and_return(uploaded_file)
    uploaded_file
  end

  describe '#execute' do

    let(:approval) { create(:status_of_approval_is_disconfirm, created_user_id: user1.id) }
    let!(:approvla_user) { create(:approval_user, approval: approval, user: user2) }
    let!(:approval_file) { create(:approval_file, approval: approval) }

    before do
      allow(ApprovalMailer).to receive_message_chain(:update_approval, :deliver_now).and_return(true)
      chatwork_approval = instance_double(Chatwork::Approval, notify_edit: true)
      allow(Chatwork::Approval).to receive(:new).and_return(chatwork_approval)
    end

    subject { Approvals::UpdateApprovalService.new(approval_params: approval_params, update_params: update_params).execute }

    context 'when inputting correctly' do

      let(:approval_params) do
        {
          name:              'name',
          status:            10,
          category:          10,
          notes:             '',
        }
      end
      let(:update_params) { { id: approval.id } }

      it do
        is_expected.to be_truthy
        prv_approval = Approval.find(approval.id)
        expect(prv_approval.name).to eq 'name'
        expect(prv_approval.category).to eq 10
      end
    end

    context 'when inputting correctly with the file' do

      let(:approval_params) do
        {
          name:              'name',
          status:            10,
          category:          10,
          notes:             "",
          files_attributes: {
            0 => {
              id: approval_file.id,
              file: uploaded_file,
            },
          },
        }
      end
      let(:update_params) { { id: approval.id } }

      it do
        is_expected.to be_truthy
        prv_approval = Approval.find(approval.id)
        expect(prv_approval.name).to eq 'name'
        expect(prv_approval.category).to eq 10
        expect(prv_approval.files.first.original_filename).to eq "sample.jpg"
      end
    end

    context 'when not set name' do

      let(:approval_params) do
        {
          name:              '',
          status:            10,
          category:          10,
          notes:             "",
        }
      end
      let(:update_params) { { id: approval.id } }

      it { is_expected.to be_falsey }
    end

  end
end
