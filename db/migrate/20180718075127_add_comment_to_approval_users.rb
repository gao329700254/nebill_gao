class AddCommentToApprovalUsers < ActiveRecord::Migration
  def change
    add_column :approval_users, :comment, :string
  end
end
