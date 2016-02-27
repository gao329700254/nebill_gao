require 'rails_helper'

RSpec.describe ProjectGroup do
  let(:project_group) { build(:project_group) }
  subject { project_group }

  it { is_expected.to respond_to(:name) }

  it { is_expected.to have_many(:projects) }
end
