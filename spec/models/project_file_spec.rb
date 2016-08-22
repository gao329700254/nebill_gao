require 'rails_helper'

RSpec.describe ProjectFile do
  let(:project_file) { build(:project_file) }
  subject { project_file }

  it { is_expected.to respond_to(:file) }

  it { is_expected.to validate_presence_of(:file) }
end
