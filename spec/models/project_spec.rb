require 'rails_helper'

RSpec.describe Project do
  let(:project) { build(:project) }
  subject { project }

  it { is_expected.to respond_to(:cd) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:contracted?) }
  it { is_expected.to respond_to(:contract_on) }
  it { is_expected.to respond_to(:contract_type) }
  it { is_expected.to respond_to(:estimated_amount) }
  it { is_expected.to respond_to(:is_using_ses) }
  it { is_expected.to respond_to(:start_on) }
  it { is_expected.to respond_to(:end_on) }
  it { is_expected.to respond_to(:amount) }
  it { is_expected.to respond_to(:payment_type) }
  it { is_expected.to respond_to(:billing) }
  it { is_expected.to respond_to(:orderer) }
  it { is_expected.to respond_to(:files) }

  it { is_expected.to belong_to(:group).class_name('ProjectGroup') }
  it { is_expected.to have_many(:members).dependent(:destroy) }
  it { is_expected.to have_many(:user_members) }
  it { is_expected.to have_many(:partner_members) }
  it { is_expected.to have_many(:employees).through(:members) }
  it { is_expected.to have_many(:users).through(:user_members) }
  it { is_expected.to have_many(:partners).through(:partner_members) }
  it { is_expected.to have_many(:bills).dependent(:destroy) }
  it { is_expected.to have_many(:files).class_name('ProjectFile').dependent(:destroy) }
  it { is_expected.to have_many(:file_groups).class_name('ProjectFileGroup').dependent(:destroy) }

  it { is_expected.to validate_presence_of(:cd) }
  it { is_expected.to validate_uniqueness_of(:cd).case_insensitive }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:contract_on) }
  it { is_expected.to validate_numericality_of(:amount).only_integer }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:amount).allow_nil }
  it { is_expected.to validate_numericality_of(:estimated_amount).only_integer }
  it { is_expected.to validate_numericality_of(:estimated_amount).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:estimated_amount).allow_nil }

  describe 'Contracted Project' do
    let(:project) { build(:contracted_project) }
    subject { project }

    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:contract_type) }
    it { is_expected.to validate_presence_of(:start_on) }
    it { is_expected.to validate_presence_of(:end_on) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:payment_type) }
    it { is_expected.to validate_presence_of(:billing_company_name) }
    it { is_expected.to validate_presence_of(:billing_department_name) }
    it { is_expected.to validate_presence_of(:billing_personnel_names) }
    it { is_expected.to validate_presence_of(:billing_address) }
    it { is_expected.to validate_presence_of(:billing_zip_code) }
    it { is_expected.to validate_presence_of(:orderer_company_name) }
    it { is_expected.to validate_presence_of(:orderer_department_name) }
    it { is_expected.to validate_presence_of(:orderer_personnel_names) }
    it { is_expected.to validate_presence_of(:orderer_address) }
    it { is_expected.to validate_presence_of(:orderer_zip_code) }

    it 'should require contracted to not change to uncontracted' do
      project.contracted = false
      is_expected.to be_invalid
    end

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
    let(:project) { build(:uncontracted_project) }
    subject { project }

    it { is_expected.to be_valid }

    it { is_expected.to validate_absence_of(:contract_type) }
    it { is_expected.to validate_absence_of(:estimated_amount) }
    it { is_expected.to validate_absence_of(:start_on) }
    it { is_expected.to validate_absence_of(:end_on) }
    it { is_expected.to validate_absence_of(:amount) }
  end
end
