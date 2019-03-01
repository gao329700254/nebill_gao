require 'rails_helper'

RSpec.describe Approvals::CreateApprovalService do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  let(:uploaded_file) do
    uploaded_file = fixture_file_upload('spec/fixtures/sample.jpg', 'image/jpeg')
    allow(uploaded_file).to receive(:tempfile).and_return(uploaded_file)
    uploaded_file
  end

  describe '#execute' do

    subject { Approvals::CreateApprovalService.new(approval_params: approval_params, create_params: create_params).execute }

    context 'when inputting correctly' do
      let(:approval_params) do
        {
          name:              'name',
          created_user_id:   user1.id,
        }
      end
      let(:create_params) { { user_id: user2.id } }

      it do
        is_expected.to be_truthy
        approval = Approval.first

        expect(approval.users.count).to eq 1
        expect(approval.files.count).to eq 0
        expect(approval.name).to eq 'name'
      end
    end

    context 'when inputting correctly with the file' do
      let(:approval_params) do
        {
          name:              'name',
          created_user_id:   user1.id,
          files_attributes: {
            0 => {
              file: uploaded_file,
            },
          },
        }
      end
      let(:create_params) { { user_id: user2.id } }

      it do
        is_expected.to be_truthy
        approval = Approval.first

        expect(approval.users.count).to eq 1
        expect(approval.files.count).to eq 1
        expect(approval.name).to eq 'name'
      end
    end

    context 'when not set name' do
      let(:approval_params) do
        {
          created_user_id:   user1.id,
        }
      end
      let(:create_params) { { user_id: user2.id } }

      it { is_expected.to be_falsey }
    end

    context 'when not set user_id' do
      let(:approval_params) do
        {
          name:              'name',
          created_user_id:   user1.id,
        }
      end
      let(:create_params) { { user_id: nil } }

      it { is_expected.to be_falsey }
    end
  end
end
