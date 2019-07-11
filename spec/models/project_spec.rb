require 'rails_helper'

RSpec.describe Project do
  let(:project) { build(:project) }
  subject { project }

  it { is_expected.to respond_to(:cd) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:memo) }
  it { is_expected.to respond_to(:contracted?) }
  it { is_expected.to respond_to(:contract_on) }
  it { is_expected.to respond_to(:status) }
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
  it { is_expected.to have_many(:bills).dependent(:destroy) }
  it { is_expected.to have_many(:files).class_name('ProjectFile').dependent(:destroy) }
  it { is_expected.to have_many(:file_groups).class_name('ProjectFileGroup').dependent(:destroy) }

  it { is_expected.to validate_presence_of(:cd) }
  it { is_expected.to validate_uniqueness_of(:cd).case_insensitive }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_numericality_of(:amount) }
  it { is_expected.to validate_numericality_of(:estimated_amount) }

  it { is_expected.to be_versioned }

  describe 'Contracted Project' do
    let(:project) { build(:contracted_project) }
    subject { project }

    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:contract_type) }
    it { is_expected.to validate_presence_of(:contract_on) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:end_on) }
    it { is_expected.to validate_numericality_of(:amount) }
    it { is_expected.to validate_presence_of(:payment_type) }
    it { is_expected.to validate_presence_of(:orderer_company_name) }
    it { is_expected.to validate_presence_of(:orderer_personnel_names) }

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
      its(:phone_number)    { is_expected.to eq project.billing_phone_number }
      its(:memo)            { is_expected.to eq project.billing_memo }
    end

    describe '#orderer' do
      subject { project.orderer }
      its(:company_name)    { is_expected.to eq project.orderer_company_name }
      its(:department_name) { is_expected.to eq project.orderer_department_name }
      its(:personnel_names) { is_expected.to eq project.orderer_personnel_names }
      its(:address)         { is_expected.to eq project.orderer_address }
      its(:zip_code)        { is_expected.to eq project.orderer_zip_code }
      its(:phone_number)    { is_expected.to eq project.orderer_phone_number }
      its(:memo)            { is_expected.to eq project.orderer_memo }
    end
  end

  describe 'Uncontracted Project' do
    let(:project) { build(:uncontracted_project) }
    subject { project }

    it { is_expected.to be_valid }

    it { is_expected.to validate_absence_of(:start_on) }
    it { is_expected.to validate_absence_of(:end_on) }
    # NOTE: Matcherが値を書き換えているためエラーとなるため
    xit { is_expected.to validate_absence_of(:amount) }
  end

  describe 'Scope' do
    let!(:project1) { create(:contracted_project, start_on: 1.month.ago, end_on: 1.week.ago) }
    let!(:project2) { create(:contracted_project, start_on: 1.week.ago, end_on: 3.days.ago) }
    let!(:project3) { create(:contracted_project, start_on: 3.days.ago, end_on: 1.day.ago) }
    let!(:project4) { create(:contracted_project, start_on: 1.day.ago, end_on: 1.month.since) }

    context 'between' do
      subject { Project.between(1.month.ago, 3.days.ago) }
      it { is_expected.to include project1, project2 }
    end

    context 'gteq_start_on' do
      subject { Project.gteq_start_on(1.week.ago) }
      it { is_expected.to include project2 }
    end

    context 'lteq_end_on' do
      subject { Project.lteq_end_on(1.week.ago) }
      it { is_expected.to include project1 }
    end
  end

  describe 'CD' do
    context 'correct' do
      context '17D001' do
        let(:project) { build(:uncontracted_project, cd: '17D001') }
        subject { project }
        it { is_expected.to be_valid }
      end

      context '17D001' do
        let(:project) { build(:uncontracted_project, cd: '17D001') }
        subject { project }
        it { is_expected.to be_valid }
      end
    end

    context 'incorrect' do
      context '17' do
        let(:project) { build(:uncontracted_project, cd: '17') }
        subject { project }
        it { is_expected.not_to be_valid }
      end

      context '17D01' do
        let(:project) { build(:uncontracted_project, cd: '17D01') }
        subject { project }
        it { is_expected.not_to be_valid }
      end

      context 'D001' do
        let(:project) { build(:uncontracted_project, cd: 'D001') }
        subject { project }
        it { is_expected.not_to be_valid }
      end

      context '17001' do
        let(:project) { build(:uncontracted_project, cd: '17001') }
        subject { project }
        it { is_expected.not_to be_valid }
      end
    end
  end
end
