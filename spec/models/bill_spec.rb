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
  it { is_expected.to respond_to(:deposit_on) }
  it { is_expected.to respond_to(:memo) }

  it { is_expected.to belong_to(:project) }
  it { is_expected.to have_many(:users).through(:user_members) }
  it { is_expected.to have_many(:partners).through(:partner_members) }

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
end
