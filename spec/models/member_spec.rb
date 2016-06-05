require 'rails_helper'

RSpec.describe Member do
  let(:member) { build(:member) }
  subject { member }

  it { is_expected.to belong_to(:employee) }
  it { is_expected.to belong_to(:project) }
  it { is_expected.to have_one(:user).through(:employee).source(:actable) }
  it { is_expected.to have_one(:partner).through(:employee).source(:actable) }

  it { is_expected.to validate_uniqueness_of(:employee_id).scoped_to(:project_id) }
end
