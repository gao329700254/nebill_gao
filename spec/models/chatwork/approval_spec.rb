require 'rails_helper'

RSpec.describe Chatwork::Approval, type: :model do
  let(:faraday_mock)    { double('faraday_mock') }
  let(:chatwork_id)     { 111 }
  let(:chatwork_name)   { 'name' }
  let(:user)            { build(:user, chatwork_id: chatwork_id, chatwork_name: chatwork_name) }
  let(:approval)        { build_stubbed(:approval, created_user: build(:user)) }
  let(:faraday_mock)    { double('faraday_mock') }
  let(:response_mock)   { double('response_mock', success?: true) }
  let(:target_instance) { described_class.new(approval: approval, to_user: user) }

  before do
    allow(Rails.configuration.x).to receive(:chatwork_api_token).and_return('token')
    allow(Rails.configuration.x).to receive(:chatwork_room_id).and_return('room_id')
    allow(Faraday).to receive(:new).and_return(faraday_mock)
    allow(faraday_mock).to receive(:post).with('/v2/rooms/room_id/messages', any_args).and_return(response_mock)
    allow(ActionMailer::Base).to receive(:default_url_options).and_return(host: 'http://test.com')
  end

  describe '#user_enable?' do
    subject { target_instance.user_enable? }

    context 'when user set chatwork_id' do
      it { is_expected.to be_truthy }
    end

    context 'when user not set chatwork_id' do
      let(:chatwork_id) { nil }

      it { is_expected.to be_falsey }
    end
  end

  describe '#notify_assigned' do
    subject { target_instance.notify_assigned }

    it { is_expected.to be_truthy }
  end

  describe '#notify_permited' do
    subject { target_instance.notify_permited }

    it { is_expected.to be_truthy }
  end
end
