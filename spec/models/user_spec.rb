require 'rails_helper'

RSpec.describe User do
  let(:user) { build(:user) }
  subject { user }

  it { is_expected.to respond_to(:provider) }
  it { is_expected.to respond_to(:uid) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:persistence_token) }
  it { is_expected.to respond_to(:login_count) }
  it { is_expected.to respond_to(:failed_login_count) }
  it { is_expected.to respond_to(:current_login_at) }
  it { is_expected.to respond_to(:last_login_at) }
  it { is_expected.to respond_to(:is_admin) }

  it { is_expected.to validate_uniqueness_of(:provider).scoped_to(:uid).allow_nil }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
end
