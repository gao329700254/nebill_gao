require 'rails_helper'

RSpec.describe Chatwork::Base, type: :model do
  let(:chatwork_api_token) { 'api_token' }
  let(:chatwork_room_id)   { 'room_id' }
  let(:faraday_mock)       { double('faraday_mock') }

  before do
    allow(Rails.configuration.x).to receive(:chatwork_api_token).and_return(chatwork_api_token)
    allow(Rails.configuration.x).to receive(:chatwork_room_id).and_return(chatwork_room_id)
    allow(Faraday).to receive(:new).and_return(faraday_mock)
  end

  describe '.enable?' do
    subject { described_class.enable? }

    context 'when no enviroment variable not set' do
      let(:chatwork_api_token) { nil }
      let(:chatwork_room_id)   { nil }

      it { is_expected.to be_falsey }
    end

    context 'when CHATWORK_API_TOKEN is set' do
      let(:chatwork_api_token) { nil }

      it { is_expected.to be_falsey }
    end

    context 'when CHATWORK_ROOM_ID is set' do
      let(:chatwork_room_id) { nil }

      it { is_expected.to be_falsey }
    end

    context 'when CHATWORK_API_TOKEN and CHATWORK_ROOM_ID set' do
      it { is_expected.to be_truthy }
    end
  end

  describe '.api_prefix' do
    subject { described_class.api_prefix }

    it { expect(subject.to_s).to eq '/v2/rooms/room_id' }
    it { is_expected.to be_an_instance_of(Pathname) }
  end

  describe '#send_message' do
    let(:body) { 'body' }
    let(:response_mock) { double(:response_mock) }

    subject { described_class.new.send_message(body) }

    before do
      allow(faraday_mock).to receive(:post).with('/v2/rooms/room_id/messages', body: body).and_return(response_mock)
    end

    context 'when success post message' do
      before do
        allow(response_mock).to receive(:success?).and_return(true)
      end

      it { is_expected.to be_truthy }
    end

    context 'when fail post message' do
      before do
        allow(response_mock).to receive(:success?).and_return(false)
        allow(response_mock).to receive(:body).and_return('error')
      end

      it { is_expected.to be_falsey }
    end
  end

  describe '#render' do
    let(:template_path) { 'path/test' }
    let(:expect_path) { Pathname.new("#{Rails.root}/app/views/chatworks/path/test.txt.erb") }
    let!(:to_user) { create(:user, chatwork_id: 1, chatwork_name: '[Cuon] name') }
    let(:template_file) do
      <<-EOF
        [info]
          <%= annotate_to(User.last) %>
          [info]
            body
            body
          [/info]
        [/info]
      EOF
    end

    subject { described_class.new.render(template_path) }

    it do
      expect(File).to receive(:read).with(expect_path).and_return(template_file)
      is_expected.to eq("[info][To:1] [Cuon] nameさん\n[info]body\nbody\n[/info][/info]")
    end
  end

  describe '#annotate_to' do
    let!(:to_user) { create(:user, chatwork_id: 1, chatwork_name: '[Cuon] name') }

    subject { described_class.new.annotate_to(to_user) }

    it { is_expected.to eq('[To:1] [Cuon] nameさん') }
  end
end
