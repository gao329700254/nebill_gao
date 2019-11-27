require 'rails_helper'

RSpec.describe Bill do
  let(:bill) { build(:bill) }
  subject { bill }

  it { is_expected.to respond_to(:cd) }
  it { is_expected.to respond_to(:amount) }
  it { is_expected.to respond_to(:delivery_on) }
  it { is_expected.to respond_to(:acceptance_on) }
  it { is_expected.to respond_to(:payment_type) }
  it { is_expected.to respond_to(:bill_on) }
  it { is_expected.to respond_to(:expected_deposit_on) }
  it { is_expected.to respond_to(:memo) }

  it { is_expected.to belong_to(:project) }

  it { is_expected.to validate_presence_of(:cd) }
  it { is_expected.to validate_uniqueness_of(:cd).case_insensitive }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_presence_of(:delivery_on) }
  it { is_expected.to validate_presence_of(:acceptance_on) }

  it { is_expected.to be_versioned }

  describe 'details validation' do
    let!(:detail_01) { create(:bill_detail, bill: bill) }
    let!(:detail_02) { create(:bill_detail, bill: bill) }
    let!(:detail_03) { create(:bill_detail, bill: bill) }
    let!(:detail_04) { create(:bill_detail, bill: bill) }
    let!(:detail_05) { create(:bill_detail, bill: bill) }
    let!(:detail_06) { create(:bill_detail, bill: bill) }
    let!(:detail_07) { create(:bill_detail, bill: bill) }
    let!(:detail_08) { create(:bill_detail, bill: bill) }
    let!(:detail_09) { create(:bill_detail, bill: bill) }
    let!(:detail_10) { create(:bill_detail, bill: bill) }
    let!(:detail_11) { create(:bill_detail, bill: bill) }
    let!(:detail_12) { create(:bill_detail, bill: bill) }
    let!(:detail_13) { create(:bill_detail, bill: bill) }
    let!(:detail_14) { create(:bill_detail, bill: bill) }
    let!(:detail_15) { create(:bill_detail, bill: bill) }

    it 'cannot create new detail record' do
      bill.reload.details.build(content: 'content', amount: 1234, display_order: 16)
      bill.valid?
      expect(bill.errors.full_messages).to eq ['内訳を15行以上作成することはできません']
    end
  end

  describe "#bill_on_cannot_predate_delivery_on" do
    it "bill_on should not predate delivery_on" do
      bill.bill_on = bill.delivery_on - 1
      expect(bill).not_to be_valid
      expect(bill.errors[:bill_on]).to include(I18n.t("errors.messages.wrong_bill_on_predate_delivery_on"))
    end
  end

  describe "#bill_on_cannot_predate_acceptance_on" do
    it "bill_on should not predate acceptance_on" do
      bill.bill_on = bill.acceptance_on - 1
      expect(bill).not_to be_valid
      expect(bill.errors[:bill_on]).to include(I18n.t("errors.messages.wrong_bill_on_predate_acceptance_on"))
    end
  end

  describe 'Scope' do
    let!(:bill1) { create(:bill, expected_deposit_on: "2019-11-15") }
    let!(:bill2) { create(:bill, expected_deposit_on: "2019-10-15") }
    let!(:bill3) { create(:bill, expected_deposit_on: "2019-09-15") }
    let!(:bill4) { create(:bill, expected_deposit_on: "2019-08-15") }

    context 'expected_deposit_on_between' do
      subject { Bill.expected_deposit_on_between("2019-10-15", "2019-11-15") }
      it { is_expected.to include bill1, bill2 }
    end

    context 'gteq_expected_deposit_on_start_on' do
      subject { Bill.gteq_expected_deposit_on_start_on("2019-11-15") }
      it { is_expected.to include bill1 }
    end

    context 'lteq_expected_deposit_on_end_on' do
      subject { Bill.lteq_expected_deposit_on_end_on("2019-10-15") }
      it { is_expected.to include bill2, bill3, bill4 }
    end
  end
end
