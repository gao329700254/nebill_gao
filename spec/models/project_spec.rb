require 'rails_helper'

RSpec.describe Project do
  let(:project) { build(:project) }
  subject { project }

  it { is_expected.to respond_to(:key) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:contracted?) }
  it { is_expected.to respond_to(:contract_on) }
  it { is_expected.to respond_to(:contract_type) }
  it { is_expected.to respond_to(:start_on) }
  it { is_expected.to respond_to(:end_on) }
  it { is_expected.to respond_to(:amount) }
  it { is_expected.to respond_to(:billing) }
  it { is_expected.to respond_to(:orderer) }

  it { is_expected.to validate_presence_of(:key) }
  it { is_expected.to validate_uniqueness_of(:key) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:contract_on) }
  it { is_expected.to validate_numericality_of(:amount).only_integer }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:amount).allow_nil }

  describe 'Contracted Project' do
    let(:project) { build(:contracted_project) }
    subject { project }

    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:contract_type) }
    it { is_expected.to validate_presence_of(:start_on) }
    it { is_expected.to validate_presence_of(:end_on) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:billing_company_name) }
    it { is_expected.to validate_presence_of(:billing_department_name) }
    it { is_expected.to validate_presence_of(:billing_personnel_names) }
    it { is_expected.to validate_presence_of(:billing_address) }
    it { is_expected.to validate_presence_of(:billing_zip_code) }
    it { is_expected.to validate_presence_of(:billing_memo) }
    it { is_expected.to validate_presence_of(:orderer_company_name) }
    it { is_expected.to validate_presence_of(:orderer_department_name) }
    it { is_expected.to validate_presence_of(:orderer_personnel_names) }
    it { is_expected.to validate_presence_of(:orderer_address) }
    it { is_expected.to validate_presence_of(:orderer_zip_code) }
    it { is_expected.to validate_presence_of(:orderer_memo) }

    describe '#billing' do
      subject { project.billing }
      its(:company_name)    { is_expected.to eq project.billing_company_name }
      its(:department_name) { is_expected.to eq project.billing_department_name }
      its(:personnel_names) { is_expected.to eq project.billing_personnel_names }
      its(:address)         { is_expected.to eq project.billing_address }
      its(:zip_code)        { is_expected.to eq project.billing_zip_code }
      its(:memo)            { is_expected.to eq project.billing_memo }
    end

    describe '#orderer' do
      subject { project.orderer }
      its(:company_name)    { is_expected.to eq project.orderer_company_name }
      its(:department_name) { is_expected.to eq project.orderer_department_name }
      its(:personnel_names) { is_expected.to eq project.orderer_personnel_names }
      its(:address)         { is_expected.to eq project.orderer_address }
      its(:zip_code)        { is_expected.to eq project.orderer_zip_code }
      its(:memo)            { is_expected.to eq project.orderer_memo }
    end
  end

  describe 'Uncontracted Project' do
    let(:project) { build(:un_contracted_project) }
    subject { project }

    it { is_expected.to be_valid }

    it { is_expected.to validate_absence_of(:contract_type) }
    it { is_expected.to validate_absence_of(:start_on) }
    it { is_expected.to validate_absence_of(:end_on) }
    it { is_expected.to validate_absence_of(:amount) }
  end
end