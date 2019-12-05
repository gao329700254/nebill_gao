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

    it 'should not require end_on to regular contract project' do
      project.is_regular_contract = true
      is_expected.not_to validate_presence_of(:end_on)
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

  describe 'calc_expected_deposit_on' do
    subject { project.calc_expected_deposit_on(payment_type, bill_on) }

    let(:project) { create(:contracted_project) }
    let(:bill_on) { Time.zone.now }

    context 'payment-type: bill_on_15th_and_payment_on_end_of_next_month' do
      let(:payment_type) { 'bill_on_15th_and_payment_on_end_of_next_month' }

      context 'today is day 14th' do
        let(:bill_on) { Time.zone.parse('2019-09-14') }
        it { is_expected.to eq Date.parse('2019-10-31') }
      end

      context 'today is day 16th' do
        let(:bill_on) { Time.zone.parse('2019-09-16') }
        it { is_expected.to eq Date.parse('2019-11-30') }
      end
    end

    context 'payment-type: bill_on_20th_and_payment_on_end_of_next_month' do
      let(:payment_type) { 'bill_on_20th_and_payment_on_end_of_next_month' }

      context 'today is day 19th' do
        let(:bill_on) { Time.zone.parse('2019-09-19') }
        it { is_expected.to eq Date.parse('2019-10-31') }
      end

      context 'today is day 21th' do
        let(:bill_on) { Time.zone.parse('2019-09-21') }
        it { is_expected.to eq Date.parse('2019-11-30') }
      end
    end

    context 'payment-type: bill_on_end_of_month_and_payment_on_end_of_next_month' do
      let(:payment_type) { 'bill_on_end_of_month_and_payment_on_end_of_next_month' }
      let(:bill_on)      { Time.zone.parse('2019-09-30') }

      it { is_expected.to eq Date.parse('2019-10-31') }
    end

    context 'payment-type: bill_on_end_of_month_and_payment_on_15th_of_month_after_next' do
      let(:payment_type) { 'bill_on_end_of_month_and_payment_on_15th_of_month_after_next' }
      let(:bill_on)      { Time.zone.parse('2019-09-30') }

      it { is_expected.to eq Date.parse('2019-11-15') }
    end

    context 'payment-type: bill_on_end_of_month_and_payment_on_20th_of_month_after_next' do
      let(:payment_type) { 'bill_on_end_of_month_and_payment_on_20th_of_month_after_next' }
      let(:bill_on)      { Time.zone.parse('2019-09-30') }

      it { is_expected.to eq Date.parse('2019-11-20') }
    end

    context 'payment-type: bill_on_end_of_month_and_payment_on_end_of_month_after_next' do
      let(:payment_type) { 'bill_on_end_of_month_and_payment_on_end_of_month_after_next' }
      let(:bill_on)      { Time.zone.parse('2019-09-30') }

      it { is_expected.to eq Date.parse('2019-11-30') }
    end

    context 'payment-type: bill_on_end_of_month_and_payment_on_35th' do
      let(:payment_type) { 'bill_on_end_of_month_and_payment_on_35th' }

      context 'last day of next month is 30' do
        let(:bill_on) { Time.zone.parse('2019-08-31') }
        it { is_expected.to eq Date.parse('2019-10-05') }
      end

      context 'last day of next month is 31' do
        let(:bill_on) { Time.zone.parse('2019-09-30') }
        it { is_expected.to eq Date.parse('2019-11-04') }
      end
    end

    context 'payment-type: bill_on_end_of_month_and_payment_on_45th' do
      let(:payment_type) { 'bill_on_end_of_month_and_payment_on_45th' }

      context 'last day of next month is 30' do
        let(:bill_on) { Time.zone.parse('2019-08-31') }
        it { is_expected.to eq Date.parse('2019-10-15') }
      end

      context 'last day of next month is 31' do
        let(:bill_on) { Time.zone.parse('2019-09-30') }
        it { is_expected.to eq Date.parse('2019-11-14') }
      end
    end
  end
end
