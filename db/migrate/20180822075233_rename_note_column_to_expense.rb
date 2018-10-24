class RenameNoteColumnToExpense < ActiveRecord::Migration
  def change
    rename_column :expenses, :note, :notes
    rename_column :expense_approvals, :note, :notes
  end
end
