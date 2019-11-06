require 'rails_helper'

RSpec.describe Api::AgreementsController, type: :request do
  describe 'GET /api/agreements/bill_list' do
    subject do
      get '/api/agreements/bill_list'
      @bill_list = JSON.parse(response.body)
    end

    let(:applicant)      { create(:user) }
    let(:member)         { create(:user) }
    let(:another_member) { create(:user) }
    let(:chief)          { create(:user, is_chief: true) }

    context 'ログインユーザが一段目承認者である' do
      # ログインユーザ「承認待ち」の申請
      let!(:bill_A)               { create(:bill, cd: 'BILL_A', status: 'pending') }
      let!(:applicant_A)          { create(:bill_applicant, user: applicant, bill: bill_A) }
      let!(:primary_approver_A)   { create(:bill_approval_user, bill: bill_A, user: member, status: 'pending', role: 'primary') }

      # ログインユーザ「承認済み」の申請
      let!(:bill_B)               { create(:bill, cd: 'BILL_B', status: 'pending') }
      let!(:applicant_B)          { create(:bill_applicant, user: applicant, bill: bill_B) }
      let!(:primary_approver_B)   { create(:bill_approval_user, bill: bill_B, user: member, status: 'approved', role: 'primary') }
      let!(:secondary_approver_B) { create(:bill_approval_user, bill: bill_B, user: chief,  status: 'pending',  role: 'secondary') }

      # 別ユーザ「承認待ち」の申請
      let!(:bill_C)               { create(:bill, cd: 'BILL_C', status: 'pending') }
      let!(:applicant_C)          { create(:bill_applicant, user: applicant, bill: bill_C) }
      let!(:primary_approver_C)   { create(:bill_approval_user, bill: bill_C, user: another_member, status: 'pending', role: 'primary') }

      # 「差し戻し」の申請
      let!(:bill_E)               { create(:bill, cd: 'BILL_E', status: 'sent_back') }
      let!(:applicant_E)          { create(:bill_applicant, user: applicant, bill: bill_E) }
      let!(:primary_approver_E)   { create(:bill_approval_user, bill: bill_E, user: member, status: 'sent_back', role: 'primary') }
      let!(:secondary_approver_E) { create(:bill_approval_user, bill: bill_E, user: chief,  status: 'sent_back', role: 'secondary') }

      before do
        login(member)
        subject
      end

      it '承認ページに、自分が一段目承認者で、自分の承認ステータスが「承認待ち」の申請のみが表示される' do
        expect(@bill_list.count).to eq 1
        expect(@bill_list.first['cd']).to eq 'BILL_A'
      end
    end

    context 'ログインユーザが二段目承認者である' do
      # 一段目承認者「承認済み」、ログインユーザ「承認待ち」の申請
      let!(:bill_B)               { create(:bill, cd: 'BILL_B', status: 'pending') }
      let!(:applicant_B)          { create(:bill_applicant, user: applicant, bill: bill_B) }
      let!(:primary_approver_B)   { create(:bill_approval_user, bill: bill_B, user: member, status: 'approved', role: 'primary') }
      let!(:secondary_approver_B) { create(:bill_approval_user, bill: bill_B, user: chief,  status: 'pending',  role: 'secondary') }

      # 一段目承認者「承認済み」、ログインユーザ「承認済み」の申請
      let!(:bill_C)               { create(:bill, cd: 'BILL_C', status: 'approved') }
      let!(:applicant_C)          { create(:bill_applicant, user: applicant, bill: bill_C) }
      let!(:primary_approver_C)   { create(:bill_approval_user, bill: bill_C, user: member, status: 'approved', role: 'primary') }
      let!(:secondary_approver_C) { create(:bill_approval_user, bill: bill_C, user: chief,  status: 'approved', role: 'secondary') }

      # 「差し戻し」の申請
      let!(:bill_E)               { create(:bill, cd: 'BILL_E', status: 'sent_back') }
      let!(:applicant_E)          { create(:bill_applicant, user: applicant, bill: bill_E) }
      let!(:primary_approver_E)   { create(:bill_approval_user, bill: bill_E, user: member, status: 'sent_back', role: 'primary') }
      let!(:secondary_approver_E) { create(:bill_approval_user, bill: bill_E, user: chief,  status: 'sent_back', role: 'secondary') }

      before do
        login(chief)
        subject
      end

      it '承認ページに、一段目承認者が「承認済み」で、自分の承認ステータスが「承認待ち」の申請のみが表示される' do
        expect(@bill_list.count).to eq 1
        expect(@bill_list.first['cd']).to eq 'BILL_B'
      end
    end
  end
end
