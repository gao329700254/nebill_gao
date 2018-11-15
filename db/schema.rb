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

ActiveRecord::Schema.define(version: 20181113090720) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "approval_files", force: :cascade do |t|
    t.integer  "approval_id",       null: false
    t.string   "file",              null: false
    t.string   "original_filename", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "approval_users", force: :cascade do |t|
    t.integer  "approval_id"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "comment"
  end

  add_index "approval_users", ["approval_id", "user_id"], name: "index_approval_users_on_approval_id_and_user_id", unique: true, using: :btree
  add_index "approval_users", ["approval_id"], name: "index_approval_users_on_approval_id", using: :btree
  add_index "approval_users", ["user_id"], name: "index_approval_users_on_user_id", using: :btree

  create_table "approvals", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "project_id"
    t.integer  "created_user_id", null: false
    t.string   "notes"
    t.integer  "approved_id"
    t.string   "approved_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "status"
    t.integer  "category"
  end

  add_index "approvals", ["approved_type", "approved_id"], name: "index_approvals_on_approved_type_and_approved_id", using: :btree

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

  create_table "client_files", force: :cascade do |t|
    t.integer  "client_id",         null: false
    t.string   "file",              null: false
    t.string   "original_filename", null: false
    t.integer  "type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

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

  create_table "default_expense_items", force: :cascade do |t|
    t.string   "name"
    t.string   "display_name"
    t.integer  "standard_amount"
    t.boolean  "is_routing"
    t.boolean  "is_quantity"
    t.string   "note"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "is_receipt"
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

  create_table "expense_approval_users", force: :cascade do |t|
    t.integer  "expense_approval_id"
    t.integer  "user_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "status"
    t.string   "comment"
  end

  create_table "expense_approvals", force: :cascade do |t|
    t.integer  "total_amount"
    t.string   "notes"
    t.integer  "status"
    t.integer  "created_user_id"
    t.integer  "expenses_number"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "name"
  end

  create_table "expense_files", force: :cascade do |t|
    t.integer  "expense_id"
    t.string   "file"
    t.string   "original_filename"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.integer  "default_id"
    t.date     "use_date"
    t.integer  "amount"
    t.string   "depatture_location"
    t.string   "arrival_location"
    t.integer  "quantity"
    t.string   "notes"
    t.integer  "payment_type"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "created_user_id"
    t.integer  "expense_approval_id"
    t.boolean  "is_round_trip",       default: false
    t.integer  "project_id"
  end

  create_table "members", force: :cascade do |t|
    t.integer  "employee_id",    null: false
    t.string   "type",           null: false
    t.integer  "unit_price"
    t.integer  "min_limit_time"
    t.integer  "max_limit_time"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.float    "working_rate"
    t.integer  "bill_id",        null: false
  end

  add_index "members", ["bill_id"], name: "index_members_on_bill_id", using: :btree
  add_index "members", ["employee_id", "bill_id"], name: "index_members_on_employee_id_and_bill_id", unique: true, using: :btree
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

  create_table "payee_accounts", force: :cascade do |t|
    t.integer "employee_id",             null: false
    t.integer "bank_code"
    t.integer "filial_code"
    t.integer "inv_type"
    t.string  "inv_number",  limit: 15
    t.string  "employee",    limit: 200
    t.string  "bank_name"
    t.string  "filial_name"
  end

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
    t.integer  "type"
  end

  create_table "project_groups", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "cd",                                      null: false
    t.string   "name",                                    null: false
    t.boolean  "contracted",                              null: false
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
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "is_using_ses"
    t.integer  "group_id"
    t.string   "payment_type"
    t.string   "billing_personnel_names",                              array: true
    t.string   "orderer_personnel_names",                              array: true
    t.integer  "estimated_amount"
    t.boolean  "is_regular_contract"
    t.string   "status"
    t.string   "orderer_phone_number"
    t.string   "billing_phone_number"
    t.text     "memo"
    t.boolean  "unprocessed",             default: false
  end

  add_index "projects", ["cd"], name: "index_projects_on_cd", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "persistence_token",               null: false
    t.integer  "login_count",        default: 0,  null: false
    t.integer  "failed_login_count", default: 0,  null: false
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "role",               default: 10, null: false
    t.integer  "default_allower"
    t.integer  "chatwork_id"
    t.string   "chatwork_name"
  end

  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.integer  "bill_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "approval_users", "approvals", on_delete: :cascade
  add_foreign_key "approval_users", "users", on_delete: :cascade
  add_foreign_key "bills", "projects", on_delete: :cascade
  add_foreign_key "expense_approval_users", "expense_approvals", on_delete: :nullify
  add_foreign_key "expense_approval_users", "users", on_delete: :nullify
  add_foreign_key "expense_approvals", "users", column: "created_user_id", on_delete: :nullify
  add_foreign_key "expense_files", "expenses", on_delete: :nullify
  add_foreign_key "expenses", "default_expense_items", column: "default_id", on_delete: :nullify
  add_foreign_key "expenses", "expense_approvals", on_delete: :nullify
  add_foreign_key "expenses", "projects", on_delete: :nullify
  add_foreign_key "expenses", "users", column: "created_user_id", on_delete: :nullify
  add_foreign_key "members", "bills", on_delete: :cascade
  add_foreign_key "members", "employees", on_delete: :cascade
  add_foreign_key "project_file_groups", "projects", on_delete: :cascade
  add_foreign_key "project_files", "projects", on_delete: :cascade
  add_foreign_key "projects", "project_groups", column: "group_id", on_delete: :nullify
  add_foreign_key "users", "users", column: "default_allower", on_delete: :nullify
end
