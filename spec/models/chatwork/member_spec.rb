require 'rails_helper'

RSpec.describe Chatwork::Member, type: :model do
  let(:chatwork_api_token) { 'api_token' }
  let(:chatwork_room_id)   { 'room_id' }
  let(:faraday_mock)       { double('faraday_mock') }
  let(:faraday_mock)       { double('faraday_mock') }
  let(:response_mock)      { double('response_mock', success?: respose_status, body: response_json) }
  let(:respose_status)     { true }
  let(:response_json)      do
    <<-EOF
    [
      {"account_id":1234567,"role":"member","name":"A","chatwork_id":"","organization_id":51186,"organization_name":"Cuon","department":"","avatar_image_url":"https://appdata.chatwork.com/avatar.png"},
      {"account_id":1234568,"role":"admin", "name":"B","chatwork_id":"","organization_id":51186,"organization_name":"Cuon","department":"","avatar_image_url":"https://appdata.chatwork.com/avatar.png"}
    ]
    EOF
  end

  before do
    allow(ENV).to receive(:[]).with('CHATWORK_API_TOKEN').and_return(chatwork_api_token)
    allow(ENV).to receive(:[]).with('CHATWORK_ROOM_ID').and_return(chatwork_room_id)
    allow(Faraday).to receive(:new).and_return(faraday_mock)
    allow(faraday_mock).to receive(:get).with('/v2/rooms/room_id/members').and_return(response_mock)
  end

  describe '.member_list' do
    subject { described_class.member_list }

    it do
      is_expected.to contain_exactly(
        {
          account_id:         1_234_567,
          role:               'member',
          name:               'A',
          chatwork_id:        '',
          organization_id:    51_186,
          organization_name:  'Cuon',
          department:         '',
          avatar_image_url:   'https://appdata.chatwork.com/avatar.png',
        },
        account_id:        1_234_568,
        role:              'admin',
        name:              'B',
        chatwork_id:       '',
        organization_id:   51_186,
        organization_name: 'Cuon',
        department:        '',
        avatar_image_url:  'https://appdata.chatwork.com/avatar.png',
      )
    end
    context 'when not set CHATWORK_API_TOKEN' do
      let(:chatwork_api_token) { nil }

      it { is_expected.to eq([]) }
    end

    context 'when fail called chatwork api ' do
      let(:respose_status) { false }

      it { is_expected.to eq([]) }
    end

  end
end
