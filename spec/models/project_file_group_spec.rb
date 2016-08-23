require 'rails_helper'

RSpec.describe ProjectFileGroup, type: :model do
  let(:project_file_group) { build(:project_file_group) }
  subject { project_file_group }

  it { is_expected.to respond_to(:name) }

  it { is_expected.to belong_to(:project) }
  it { is_expected.to have_many(:files).class_name('ProjectFile').with_foreign_key(:file_group_id) }

  it { is_expected.to validate_presence_of(:name) }
end
