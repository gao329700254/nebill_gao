# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160126045155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "projects", force: :cascade do |t|
    t.string   "key",                     null: false
    t.string   "name",                    null: false
    t.boolean  "contracted",              null: false
    t.date     "contract_on",             null: false
    t.string   "contract_type"
    t.date     "start_on"
    t.date     "end_on"
    t.integer  "amount"
    t.string   "billing_company_name"
    t.string   "billing_department_name"
    t.string   "billing_personnel_names"
    t.string   "billing_address"
    t.string   "billing_zip_code"
    t.text     "billing_memo"
    t.string   "orderer_company_name"
    t.string   "orderer_department_name"
    t.string   "orderer_personnel_names"
    t.string   "orderer_address"
    t.string   "orderer_zip_code"
    t.text     "orderer_memo"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "projects", ["key"], name: "index_projects_on_key", unique: true, using: :btree

end
