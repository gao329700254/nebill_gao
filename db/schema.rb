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

ActiveRecord::Schema.define(version: 20170905092430) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bills", force: :cascade do |t|
    t.integer  "project_id",                null: false
    t.string   "cd",                        null: false
    t.date     "delivery_on",               null: false
    t.date     "acceptance_on",             null: false
    t.date     "bill_on"
    t.date     "deposit_on"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "memo"
    t.integer  "amount",        default: 0, null: false
    t.string   "payment_type"
  end

  add_index "bills", ["cd"], name: "index_bills_on_cd", unique: true, using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "cd"
    t.string   "company_name",    null: false
    t.string   "department_name"
    t.string   "address"
    t.string   "zip_code"
    t.string   "phone_number"
    t.text     "memo"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "employees", force: :cascade do |t|
    t.integer  "actable_id",   null: false
    t.string   "actable_type", null: false
    t.string   "name"
    t.string   "email",        null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "employees", ["email"], name: "index_employees_on_email", unique: true, using: :btree

  create_table "members", force: :cascade do |t|
    t.integer  "employee_id",    null: false
    t.integer  "project_id",     null: false
    t.string   "type",           null: false
    t.integer  "unit_price"
    t.integer  "min_limit_time"
    t.integer  "max_limit_time"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.float    "working_rate"
  end

  add_index "members", ["employee_id", "project_id"], name: "index_members_on_employee_id_and_project_id", unique: true, using: :btree
  add_index "members", ["project_id"], name: "index_members_on_project_id", using: :btree
  add_index "members", ["type"], name: "index_members_on_type", using: :btree

  create_table "partners", force: :cascade do |t|
    t.string   "company_name", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "cd",           null: false
    t.string   "address"
    t.string   "zip_code"
    t.string   "phone_number"
  end

  add_index "partners", ["cd"], name: "index_partners_on_cd", using: :btree

  create_table "project_file_groups", force: :cascade do |t|
    t.integer  "project_id", null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_files", force: :cascade do |t|
    t.integer  "project_id",        null: false
    t.string   "file",              null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "file_group_id"
    t.string   "original_filename", null: false
  end

  create_table "project_groups", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "cd",                      null: false
    t.string   "name",                    null: false
    t.boolean  "contracted",              null: false
    t.date     "contract_on"
    t.string   "contract_type"
    t.date     "start_on"
    t.date     "end_on"
    t.integer  "amount"
    t.string   "billing_company_name"
    t.string   "billing_department_name"
    t.string   "billing_address"
    t.string   "billing_zip_code"
    t.text     "billing_memo"
    t.string   "orderer_company_name"
    t.string   "orderer_department_name"
    t.string   "orderer_address"
    t.string   "orderer_zip_code"
    t.text     "orderer_memo"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.boolean  "is_using_ses"
    t.integer  "group_id"
    t.string   "payment_type"
    t.string   "billing_personnel_names",              array: true
    t.string   "orderer_personnel_names",              array: true
    t.integer  "estimated_amount"
    t.boolean  "is_regular_contract"
    t.string   "status"
  end

  add_index "projects", ["cd"], name: "index_projects_on_cd", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "persistence_token",                  null: false
    t.integer  "login_count",        default: 0,     null: false
    t.integer  "failed_login_count", default: 0,     null: false
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.boolean  "is_admin",           default: false, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "role",               default: 10,    null: false
  end

  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree

  add_foreign_key "bills", "projects", on_delete: :cascade
  add_foreign_key "members", "employees", on_delete: :cascade
  add_foreign_key "members", "projects", on_delete: :cascade
  add_foreign_key "project_file_groups", "projects", on_delete: :cascade
  add_foreign_key "project_files", "projects", on_delete: :cascade
  add_foreign_key "projects", "project_groups", column: "group_id", on_delete: :nullify
end
