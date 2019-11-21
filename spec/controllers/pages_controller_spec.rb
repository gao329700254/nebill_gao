require 'rails_helper'

RSpec.describe PagesController do

  subject { response }

  describe 'GET #home' do

    context 'when not logged in' do
      before { get :home }

      it { is_expected.to render_template :home }
    end

    context 'when logged in' do
      let(:user) { create(:user) }
      before { login(user) }
      before { get :home }

      it { is_expected.to redirect_to :project_list }
    end
  end

  describe 'GET #project_new_form' do
    context 'when not logged in' do
      before { get :project_new_form }

      it { is_expected.to redirect_to root_path }
    end
    context 'when logged in' do
      let(:user) { create(:user) }
      before do
        login(user)
        get :project_new_form
      end

      it { is_expected.to render_template :project_new_form }
    end
  end

  describe 'GET #project_list' do
    context 'when not logged in' do
      before { get :project_list }

      it { is_expected.to redirect_to root_path }
    end
    context 'when logged in' do
      let(:user) { create(:user) }
      before { login(user) }
      before { get :project_list }

      it { is_expected.to render_template :project_list }
    end
  end

  describe 'GET #bill_list' do
    context 'when not logged in' do
      before { get :bill_list }

      it { is_expected.to redirect_to root_path }
    end
    context 'when logged in' do
      let(:user) { create(:user) }
      before { login(user) }
      before { get :bill_list }

      it { is_expected.to render_template :bill_list }
    end
  end

  describe 'GET #partner_list' do
    context 'when not logged in' do
      before { get :partner_list }

      it { is_expected.to redirect_to root_path }
    end
    context 'when logged in' do
      let(:user) { create(:user) }
      before { login(user) }
      before { get :partner_list }

      it { is_expected.to render_template :partner_list }
    end
  end

  describe 'GET #client_list' do
    context 'when not logged in' do
      before { get :client_list }

      it { is_expected.to redirect_to root_path }
    end
    context 'when logged in' do
      let(:user) { create(:user) }
      before { login(user) }
      before { get :client_list }

      it { is_expected.to render_template :client_list }
    end
  end

  describe 'GET #approval_list' do
    context 'when not logged in' do
      before { get :approval_list }

      it { is_expected.to redirect_to root_path }
    end
    context 'when logged in' do
      let(:user) { create(:user) }
      before { login(user) }
      before { get :approval_list }

      it { is_expected.to render_template :approval_list }
    end
  end
end
