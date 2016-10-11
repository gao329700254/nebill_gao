class AddForeignKeysToTables < ActiveRecord::Migration
  def change
    add_foreign_key :bills              , :projects      , on_delete: :cascade
    add_foreign_key :project_files      , :projects      , on_delete: :cascade
    add_foreign_key :project_file_groups, :projects      , on_delete: :cascade
    add_foreign_key :members            , :projects      , on_delete: :cascade
    add_foreign_key :members            , :employees     , on_delete: :cascade
    add_foreign_key :projects           , :project_groups, on_delete: :nullify, column: :group_id
  end
end
