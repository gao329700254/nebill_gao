require 'rails_helper'

RSpec.describe Approval, type: :request do
  let(:user) { create(:user) }
  before { login(user) }

  describe 'POST /api/approvals/:approval_id/invalid' do
    let(:path) { "/api/approvals/#{approval.id}/invalid" }
    let(:params) { { approval_id: approval.id } }
    subject { approval.reload }

    context 'approval in user approval' do
      let(:approval) { create(:approval, :user_approval, created_user: user) }
      before { post path, params: params }

      it 'changes approval.status to "invalid"' do
        expect(subject.status).to eq 'invalid'
      end
      it 'changes statuses of all approval_users to invalid' do
        expect(subject.approval_users.size).not_to eq 0
        expect(subject.approval_users.all? { |approval_user| approval_user.status == :invalid }).to eq true
      end
    end

    context 'approval in group approval' do
      let(:approval) { create(:approval, :group_approval, created_user: user) }
      before { post path, params: params }

      it 'changes approval.status to "invalid"' do
        expect(subject.status).to eq 'invalid'
      end
      it 'changes statuses of all approval_users to invalid' do
        expect(subject.approval_users.size).not_to eq 0
        expect(subject.approval_users.all? { |approval_user| approval_user.status == :invalid }).to eq true
      end
    end
  end

  describe 'POST /api/approvals' do
    let(:path)                 { "/api/approvals" }
    let(:default_allower)      { create(:user) }
    before                     { user.update_attributes(default_allower: default_allower.id) }

    context 'with correct parameter by submit' do
      let(:params) do
        {
          approval: {
            created_user_id: user.id,
            name:            "approval" },
          button:            "submit",
        }
      end

      it 'create a approval' do
        expect do
          post path, params: params
        end.to change(Approval, :count).by(1)
        expect(response).to redirect_to approval_show_path(approval_id: assigns(:approval).id)
      end
    end

    context 'with uncorrect parameter by submit' do
      let(:params) do
        {
          approval: {
            created_user_id: user.id,
            name:            "" },
          button:            "submit",
        }
      end

      it 'do not create a approval' do
        expect do
          post path, params: params
        end.not_to change(Approval, :count)
        expect(response).to redirect_to approval_new_path
        expect(flash[:error]).to eq "稟議が作成できませんでした \n 件名を入力してください"
      end
    end

    context 'with correct parameter by repeat' do
      let(:params) do
        {
          approval: {
            created_user_id: user.id,
            name:            "approval" },
          button:            "repeat",
        }
      end

      it 'create a approval' do
        expect do
          post path, params: params
        end.to change(Approval, :count).by(1)
        expect(response).to redirect_to approval_new_path
      end
    end

    context 'with uncorrect parameter by repeat' do
      let(:params) do
        {
          approval: {
            created_user_id: user.id,
            name:            "" },
          button:            "repeat",
        }
      end

      it 'do not create a approval' do
        expect do
          post path, params: params
        end.not_to change(Approval, :count)
        expect(response).to redirect_to approval_new_path
        expect(flash[:error]).to eq "稟議が作成できませんでした \n 件名を入力してください"
      end
    end
  end

  describe 'GET  /api/approvals/:approval_id/approval_files' do
    let(:path) { "/api/approvals/#{approval.id}/approval_files" }
    let(:approval) { create(:approval, :user_approval, created_user: user) }
    let(:approval_files) { create_list(:approval_file, 3, approval: approval) }

    subject { get path }

    context 'check schema' do
      it do
        approval_files
        subject

        expect(json).to have_key('approval_files')
        expect(json['approval_files']).to be_an_instance_of(Array)
        expect(json['approval_files'].length).to eq(3)
        expect(json['approval_files'][0]).to have_key('id')
        expect(json['approval_files'][0]).to have_key('original_filename')
      end
    end
  end
end
