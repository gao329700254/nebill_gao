class CreateClientFiles < ActiveRecord::Migration
  def change
    create_table :client_files do |t|
      t.integer  "client_id",        null: false
      t.string   "file",              null: false
      t.string   "original_filename", null: false
      t.integer  "type"

      t.timestamps null: false
    end
  end
end
