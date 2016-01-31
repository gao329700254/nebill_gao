require 'rails_helper'

RSpec.describe Project do
  let(:destination_information) { build(:destination_information) }
  subject { destination_information }

  it { is_expected.to respond_to(:company_name) }
  it { is_expected.to respond_to(:department_name) }
  it { is_expected.to respond_to(:personnel_names) }
  it { is_expected.to respond_to(:address) }
  it { is_expected.to respond_to(:zip_code) }
  it { is_expected.to respond_to(:memo) }
end
