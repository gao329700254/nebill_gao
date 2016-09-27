require 'rails_helper'

RSpec.describe UserMember do
  let(:user_member) { build(:user_member) }
  subject { user_member }

  it { is_expected.to have_one(:user).through(:employee).source(:actable) }
  it { is_expected.to validate_absence_of(:unit_price) }
  it { is_expected.to validate_absence_of(:min_limit_time) }
  it { is_expected.to validate_absence_of(:max_limit_time) }
end
