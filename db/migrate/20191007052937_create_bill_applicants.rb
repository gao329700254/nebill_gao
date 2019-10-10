class CreateBillApplicants < ActiveRecord::Migration[5.0]
  def change
    create_table :bill_applicants do |t|
      t.string     :comment
      t.references :user, foreign_key: true
      t.references :bill, foreign_key: true

      t.timestamps
    end
  end
end
