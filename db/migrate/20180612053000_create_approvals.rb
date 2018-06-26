class CreateApprovals < ActiveRecord::Migration
  def change
    create_table :approvals do |t|
      t.string     :name, null: false
      t.string     :project_id
      t.integer    :created_user_id, null: false
      t.string     :notes
      t.references :approved, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
