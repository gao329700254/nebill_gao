require 'rails_helper'

RSpec.describe Project do
  let(:project) { build(:project) }
  subject { project }

  it { is_expected.to respond_to(:key) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:contract_type) }
  it { is_expected.to respond_to(:start_on) }
  it { is_expected.to respond_to(:end_on) }
  it { is_expected.to respond_to(:amount) }
  it { is_expected.to respond_to(:billing) }
  it { is_expected.to respond_to(:orderer) }

  it { is_expected.to validate_presence_of(:key) }
  it { is_expected.to validate_uniqueness_of(:key) }
  it { is_expected.to validate_presence_of(:contract_type) }
  it { is_expected.to validate_presence_of(:start_on) }
  it { is_expected.to validate_numericality_of(:amount).only_integer }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }

  it { expect(project.billing.company_name).to    eq project.billing_company_name }
  it { expect(project.billing.department_name).to eq project.billing_department_name }
  it { expect(project.billing.personnel_names).to eq project.billing_personnel_names }
  it { expect(project.billing.address).to         eq project.billing_address }
  it { expect(project.billing.zip_code).to        eq project.billing_zip_code }
  it { expect(project.billing.memo).to            eq project.billing_memo }
  it { expect(project.orderer.company_name).to    eq project.orderer_company_name }
  it { expect(project.orderer.department_name).to eq project.orderer_department_name }
  it { expect(project.orderer.personnel_names).to eq project.orderer_personnel_names }
  it { expect(project.orderer.address).to         eq project.orderer_address }
  it { expect(project.orderer.zip_code).to        eq project.orderer_zip_code }
  it { expect(project.orderer.memo).to            eq project.orderer_memo }
end
