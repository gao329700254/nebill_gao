require 'rails_helper'

RSpec.describe PagesController do

  subject { response }

  describe 'GET #home' do
    before { get :home }

    it { is_expected.to render_template :home }
  end

  describe 'GET #project_new' do
    context 'when not logged in' do
      before { get :project_new }

      it { is_expected.to redirect_to root_path }
    end
    context 'when logged in' do
      let(:user) { create(:user) }
      before { login(user) }
      before { get :project_new }

      it { is_expected.to render_template :project_new }
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

  describe 'GET #partners' do
    context 'when not logged in' do
      before { get :partners }

      it { is_expected.to redirect_to root_path }
    end
    context 'when logged in' do
      let(:user) { create(:user) }
      before { login(user) }
      before { get :partners }

      it { is_expected.to render_template :partners }
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
end
