class CreateExpenseFiles < ActiveRecord::Migration
  def change
    create_table :expense_files do |t|
      t.integer :expense_id
      t.string :file
      t.string :original_filename

      t.timestamps null: false
    end
  end
end
