require 'rails_helper'

RSpec.describe ProjectFile do
  let(:project_file) { build(:project_file) }
  subject { project_file }

  it { is_expected.to respond_to(:file) }

  it { is_expected.to belong_to(:project) }
  it { is_expected.to belong_to(:group).class_name('ProjectFileGroup').with_foreign_key(:file_group_id) }

  it { is_expected.to validate_presence_of(:file) }
  it { is_expected.to validate_presence_of(:original_filename) }

  it { is_expected.to be_versioned }
end
