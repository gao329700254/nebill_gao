require 'rails_helper'

RSpec.describe Employee do
  let(:employee) { build(:user) }
  subject { employee }

  before { create(:user, email: 'ABC@EXAMPLE.COM') }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:email) }

  it { expect(Employee).to be_actable }
  it { is_expected.to have_many(:members) }

  it { is_expected.to validate_uniqueness_of(:provider).scoped_to(:uid).allow_nil }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to     allow_value('foo@example.com', 'foo.bar@example.com').for(:email) }
  it { is_expected.not_to allow_value('foo@example').for(:email) }
  it do
    employee.email = 'abc@example.com'
    is_expected.to be_invalid
  end
end
