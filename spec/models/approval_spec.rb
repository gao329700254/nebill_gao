require 'rails_helper'

RSpec.describe Approval, type: :model do

  describe '#search_approval' do
    let(:other_user)  { create(:user) }
    let(:approval1)   { create(:approval, :user_approval, created_user: current_user, created_at: "2019-10-10") }
    let(:approval2)   { create(:approval, :user_approval, created_user: current_user, created_at: "2019-11-11") }
    let(:approval3)   { create(:approval, :user_approval, created_user: other_user,   created_at: "2019-10-10") }
    let(:approval4)   { create(:approval, :user_approval, created_user: other_user,   created_at: "2019-11-11") }

    subject { Approval.search_approval(current_user: current_user, search_created_at: search_created_at) }

    context 'with role is general' do
      let(:current_user) { create(:user) }

      context 'and search_created_at is nil' do
        let(:search_created_at) { nil }

        it do
          is_expected.to eq [approval1, approval2]
        end
      end

      context 'and search_created_at is not nil' do
        let(:search_created_at) { "2019-10-10" }

        it do
          is_expected.to eq [approval1]
        end
      end
    end

    context 'with role is admin' do
      let(:current_user) { create(:admin_user) }

      context 'and search_created_at is nil' do
        let(:search_created_at) { nil }

        it do
          is_expected.to eq [approval1, approval2, approval3, approval4]
        end
      end

      context 'and search_created_at is not nil' do
        let(:search_created_at) { "2019-10-10" }

        it do
          is_expected.to eq [approval1, approval3]
        end
      end
    end
  end
end
