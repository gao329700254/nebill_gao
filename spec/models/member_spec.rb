require 'rails_helper'

RSpec.describe Member do
  describe 'UserMember' do
    let(:user_member) { build(:user_member) }
    subject { user_member }

    it { is_expected.to belong_to(:employee) }
    it { is_expected.to belong_to(:project) }
    it { is_expected.to validate_uniqueness_of(:employee_id).scoped_to(:project_id) }
  end

  describe 'PartnerMember' do
    let(:partner_member) { build(:partner_member) }
    subject { partner_member }

    it { is_expected.to belong_to(:employee) }
    it { is_expected.to belong_to(:project) }
    it { is_expected.to validate_uniqueness_of(:employee_id).scoped_to(:project_id) }
  end
end
