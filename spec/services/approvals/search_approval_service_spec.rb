require 'rails_helper'

RSpec.describe Approvals::SearchApprovalService do
  let!(:current_user)     { create(:user) }
  let!(:other_user)       { create(:user) }
  let!(:approval1)        do
    create(:approval, :user_approval, created_user_id: current_user.id, name: "abcdefg",
                                      created_at: "2020-10-10", status: "pending", category: "new_client")
  end
  let!(:approval2)        do
    create(:approval, :user_approval, created_user_id: current_user.id, name: "ghijklm",
                                      created_at: "2019-10-10", status: "disconfirm", category: "other")
  end
  let!(:approval3)        { create(:approval, :user_approval, created_user_id: other_user.id) }

  subject { Approvals::SearchApprovalService.new(params: search_params, current_user: current_user).execute }

  shared_examples_for 'approval1' do
    it 'should be approval1' do
      is_expected.to eq [approval1]
    end
  end

  shared_examples_for 'approval2' do
    it 'should be approval2' do
      is_expected.to eq [approval2]
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

      it 'should be approvals' do
        is_expected.to eq [approval1, approval2]
      end
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

      before do
        create_list(:approval, 19, :user_approval, created_user_id: current_user.id, created_at: "2020-10-10")
      end

      it_behaves_like 'approval2'
    end

    context 'search with one search_keyword' do
      let(:search_params) do
        {
          search_keywords:   'a',
          created_at:        '',
          status:            '',
          category:          '',
          page:              '',
        }
      end

      it_behaves_like 'approval1'
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

      it_behaves_like 'approval2'
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

      it_behaves_like 'approval2'
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

      it_behaves_like 'approval2'
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

      it_behaves_like 'approval2'
    end
  end
end
