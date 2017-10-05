# == Schema Information
# Schema version: 20171009095141
#
# Table name: versions
#
#  id         :integer          not null, primary key
#  project_id :integer
#  item_type  :string           not null
#  item_id    :integer          not null
#  event      :string           not null
#  whodunnit  :string
#  object     :text
#  created_at :datetime
#  bill_id    :integer
#
# Indexes
#
#  index_versions_on_item_type_and_item_id  (item_type,item_id)
#

class Version < PaperTrail::Version
  belongs_to :whodunnit_user, class_name: 'User', foreign_key: :whodunnit
  belongs_to :project
end
