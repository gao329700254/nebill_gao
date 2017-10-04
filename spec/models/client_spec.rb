require 'rails_helper'

RSpec.describe Client do
  let(:client) { build(:client) }
  subject { client }

  it { is_expected.to respond_to(:cd) }
  it { is_expected.to respond_to(:company_name) }
  it { is_expected.to respond_to(:department_name) }
  it { is_expected.to respond_to(:address) }
  it { is_expected.to respond_to(:zip_code) }
  it { is_expected.to respond_to(:phone_number) }
  it { is_expected.to respond_to(:memo) }

  it { is_expected.to validate_uniqueness_of(:cd).case_insensitive }
  it { is_expected.to validate_presence_of(:company_name) }

  it { is_expected.to be_versioned }
end
