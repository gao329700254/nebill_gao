require 'rails_helper'

RSpec.describe ApprovalFile, type: :request do
  let(:user) { create(:user) }
  before { login(user) }

  describe 'POST /api/approval_files/' do
    let(:path)   { "/api/approval_files/" }
    let(:file1)  { fixture_file_upload('sample.jpg') }
    let(:file2)  { fixture_file_upload('sample.xlsx') }
    let(:params) { { approval_files: { files: [file1, file2] } } }

    subject { post path, params: params }

    context 'check schema' do
      it  do
        subject
        expect(json).to have_key('approval_files')
        expect(json['approval_files']).to be_an_instance_of(Array)
        expect(json['approval_files'].length).to eq(2)
        expect(json['approval_files'][0]).to have_key('original_filename')
        expect(json['approval_files'][0]).to have_key('file_cache')
      end
    end
  end
end
