module RequestHelper
  def json
    @json ||= JSON.parse(response.body)
  end
end

RSpec.shared_context 'logged_in_user' do
  let(:current_user) { create(:user) }
  before { login(current_user) }
end
