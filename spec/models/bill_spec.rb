require 'rails_helper'

RSpec.describe Bill do
  let(:bill) { build(:bill) }
  subject { bill }

  it { is_expected.to respond_to(:key) }
  it { is_expected.to respond_to(:amount) }
  it { is_expected.to respond_to(:delivery_on) }
  it { is_expected.to respond_to(:acceptance_on) }
  it { is_expected.to respond_to(:payment_on) }
  it { is_expected.to respond_to(:bill_on) }
  it { is_expected.to respond_to(:deposit_on) }
  it { is_expected.to respond_to(:memo) }

  it { is_expected.to belong_to(:project) }

  it { is_expected.to validate_presence_of(:key) }
  it { is_expected.to validate_uniqueness_of(:key).case_insensitive }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_presence_of(:delivery_on) }
  it { is_expected.to validate_presence_of(:acceptance_on) }
  it { is_expected.to validate_presence_of(:payment_on) }

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
end
