require 'rails_helper'

RSpec.describe PagesController do

  subject { response }

  describe 'GET #home' do
    before { get :home }

    it { is_expected.to render_template :home }
  end
end
