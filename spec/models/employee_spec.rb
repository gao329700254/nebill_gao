require 'rails_helper'

RSpec.describe Employee do
  let(:employee) { build(:user) }
  subject { employee }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:email) }

  it { expect(Employee).to be_actable }
  it { is_expected.to have_many(:members) }
  it { is_expected.to have_many(:projects).through(:members) }

  it { is_expected.to validate_uniqueness_of(:provider).scoped_to(:uid).allow_nil }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
end
