require 'rails_helper'

RSpec.describe Member do
  describe 'UserMember' do
    let(:user_member) { build(:user_member) }
    subject { user_member }

    it { is_expected.to belong_to(:employee) }
    it { is_expected.to belong_to(:project) }

    it { is_expected.to be_versioned }

    describe 'validate uniqueness of project_id scoped to employee_id' do
      let(:other_user_member) { create(:user_member) }
      context 'when not validate uniqueness' do
        before do
          user_member.project  = other_user_member.project
          user_member.employee = other_user_member.employee
        end
        it { is_expected.to be_invalid }
      end

      context 'when validate uniqueness' do
        before do
          user_member.project  = other_user_member.project
        end
        it { is_expected.to be_valid }
      end
    end
  end

  describe 'PartnerMember' do
    let(:partner_member) { build(:partner_member) }
    subject { partner_member }

    it { is_expected.to belong_to(:employee) }
    it { is_expected.to belong_to(:project) }

    it { is_expected.to be_versioned }

    describe 'validate uniqueness of employee_id scoped to project_id' do
      let(:other_partner_member) { create(:partner_member) }
      context 'when not validate uniqueness' do
        before do
          partner_member.project = other_partner_member.project
          partner_member.employee = other_partner_member.employee
        end
        it { is_expected.to be_invalid }
      end

      context 'when validate uniqueness' do
        before do
          partner_member.project = other_partner_member.project
        end
        it { is_expected.to be_valid }
      end
    end
  end
end
