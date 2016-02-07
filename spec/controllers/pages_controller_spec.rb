require 'rails_helper'

RSpec.describe PagesController do

  subject { response }

  describe 'GET #home' do
    before { get :home }

    it { is_expected.to render_template :home }
  end

  describe 'GET #project_new' do
    before { get :project_new }

    it { is_expected.to render_template :project_new }
  end
end
