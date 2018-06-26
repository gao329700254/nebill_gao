class CreateApprovalFiles < ActiveRecord::Migration
  def change
    create_table :approval_files do |t|
      t.integer  "approval_id",        null: false
      t.string   "file",              null: false
      t.string   "original_filename", null: false

      t.timestamps null: false
    end
  end
end
