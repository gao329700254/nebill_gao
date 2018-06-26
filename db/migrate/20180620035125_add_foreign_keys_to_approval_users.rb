class AddForeignKeysToApprovalUsers < ActiveRecord::Migration
  def change
    add_foreign_key :approval_users              , :approvals      , on_delete: :cascade
    add_foreign_key :approval_users              , :users      , on_delete: :cascade
  end
end
