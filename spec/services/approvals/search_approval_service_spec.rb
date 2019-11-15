require 'rails_helper'

RSpec.describe Approvals::SearchApprovalService do
  let!(:current_user)     { create(:user) }
  let!(:other_user)       { create(:user) }
  let!(:approval_params1) { { created_user_id: current_user.id, name: "abcdefg", created_at: "2020-10-10", status: "pending",    category: "new_client" } }
  let!(:approval_params2) { { created_user_id: current_user.id, name: "ghijklm", created_at: "2019-10-10", status: "disconfirm", category: "other" } }
  let!(:approval_params3) { { created_user_id: other_user.id } }

  subject { Approvals::SearchApprovalService.new(params: search_params, current_user: current_user).execute }

  before do
    create_list(:approval, 20, :user_approval, approval_params1)
    create_list(:approval, 20, :user_approval, approval_params2)
    create_list(:approval, 10, :user_approval, approval_params3)
  end

  shared_examples_for 'approval_params1' do
    it 'should be approvals with approval_params1' do
      expect(subject.count).to eq 20
      subject.each do |result|
        expect(result.created_user_id).to eq current_user.id
        expect(result.name).to eq "abcdefg"
      end
    end
  end

  shared_examples_for 'approval_params2' do
    it 'should be approvals with approval_params2' do
      expect(subject.count).to eq 20
      subject.each do |result|
        expect(result.created_user_id).to eq current_user.id
        expect(result.name).to eq "ghijklm"
      end
    end
  end

  describe '#execute' do
    context 'search with empty params' do
      let(:search_params) do
        {
          search_keywords:   '',
          created_at:        '',
          status:            '',
          category:          '',
          page:              '',
        }
      end

      it_behaves_like 'approval_params1'
    end

    context 'search with page' do
      let(:search_params) do
        {
          search_keywords:   '',
          created_at:        '',
          status:            '',
          category:          '',
          page:              '2',
        }
      end

      it_behaves_like 'approval_params2'
    end

    context 'search with one search_keyword' do
      let(:search_params) do
        {
          search_keywords:   'm',
          created_at:        '',
          status:            '',
          category:          '',
          page:              '',
        }
      end

      it_behaves_like 'approval_params2'
    end

    context 'search with two search_keywords' do
      let(:search_params) do
        {
          search_keywords:   'g m',
          created_at:        '',
          status:            '',
          category:          '',
          page:              '',
        }
      end

      it_behaves_like 'approval_params2'
    end

    context 'search with created_at' do
      let(:search_params) do
        {
          search_keywords:   '',
          created_at:        '2019-10-10',
          status:            '',
          category:          '',
          page:              '',
        }
      end

      it_behaves_like 'approval_params2'
    end

    context 'search with status' do
      let(:search_params) do
        {
          search_keywords:   '',
          created_at:        '',
          status:            'disconfirm',
          category:          '',
          page:              '',
        }
      end

      it_behaves_like 'approval_params2'
    end

    context 'search with category' do
      let(:search_params) do
        {
          search_keywords:   '',
          created_at:        '',
          status:            '',
          category:          'other',
          page:              '',
        }
      end

      it_behaves_like 'approval_params2'
    end
  end
end
