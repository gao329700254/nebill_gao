require 'rails_helper'

RSpec.describe ApprovalIndividualGroupSwitch do
  let(:current_user) { create(:user) }
  let(:created_user) { create(:user) }
  let!(:other_user1) { create(:user) }
  let!(:other_user2) { create(:user) }
  let!(:other_user3) { create(:user) }
  subject { ApprovalIndividualGroupSwitch.new(approval, current_user) }

  describe '#users' do
    context '稟議グループ承認の場合' do
      let(:approval) { create(:approval, :group_approval, created_user: created_user) }

      its(:users) { is_expected.to include other_user1, other_user2, other_user3 }
      its(:users) { is_expected.not_to include created_user, *approval.approval_group.users }
    end

    context 'ユーザー承認の場合' do
      let(:approval) { create(:approval, created_user: created_user) }

      its(:users) { is_expected.to include other_user1, other_user2, other_user3 }
      its(:users) { is_expected.not_to include created_user, *approval.users }
    end
  end

  describe '#new_user' do
    let(:approval) { create(:approval, created_user: created_user) }

    its(:new_user) { is_expected.to be_kind_of User }
    its(:new_user) { is_expected.to be_new_record }
  end

  describe '#current_user_approval' do
    context 'current_userが承認者の場合' do
      let(:approval) { create(:approval, :user_approval, created_user: created_user, users: [current_user]) }

      its(:current_user_approval) { is_expected.to eq approval.approval_users.find_by(user: current_user) }
    end

    context 'current_userが承認者ではない場合' do
      let(:approval) { create(:approval, :group_approval, created_user: created_user) }

      its(:current_user_approval) { is_expected.to be_nil }
    end
  end

  describe '#approval_files' do
    let(:approval) { create(:approval, created_user: created_user) }

    its(:approval_files) { is_expected.to eq approval.files }
  end
end
