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
    let!(:bill1) { create(:bill, delivery_on: 3.months.ago) }
    let!(:bill2) { create(:bill, delivery_on: 4.months.ago) }
    let!(:bill3) { create(:bill, delivery_on: 5.months.ago) }
    let!(:bill4) { create(:bill, delivery_on: 6.months.ago) }

    context 'expected_deposit_on_between' do
      subject { Bill.expected_deposit_on_between(2.months.ago + 5.days, 1.month.ago + 5.days) }
      it { is_expected.to include bill1, bill2 }
    end

    context 'gteq_expected_deposit_on_start_on' do
      subject { Bill.gteq_expected_deposit_on_start_on(1.month.ago) }
      it { is_expected.to include bill1 }
    end

    context 'lteq_expected_deposit_on_end_on' do
      subject { Bill.lteq_expected_deposit_on_end_on(1.month.ago) }
      it { is_expected.to include bill2, bill3, bill4 }
    end
  end
end
