# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_11_23_190749) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "cpf"
    t.string "address"
    t.string "city"
    t.date "birth_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
    t.index ["cpf"], name: "index_clients_on_cpf", unique: true
    t.index ["email"], name: "index_clients_on_email", unique: true
    t.index ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true
  end

  create_table "equipment", force: :cascade do |t|
    t.string "name"
    t.string "brand"
    t.date "purchase_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id", null: false
    t.integer "equipment_price"
    t.index ["client_id"], name: "index_equipment_on_client_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id", null: false
    t.integer "status", default: 0
    t.integer "payment_method"
    t.integer "contract_period"
    t.decimal "price"
    t.string "coverage"
    t.integer "equipment_id", null: false
    t.integer "insurance_company_id"
    t.string "insurance_name"
    t.string "package_name"
    t.string "product_model"
    t.decimal "final_price"
    t.decimal "voucher_price"
    t.string "code"
    t.integer "max_period"
    t.integer "min_period"
    t.string "product_category"
    t.string "voucher_code"
    t.integer "product_category_id"
    t.index ["client_id"], name: "index_orders_on_client_id"
    t.index ["equipment_id"], name: "index_orders_on_equipment_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "equipment", "clients"
  add_foreign_key "orders", "clients"
  add_foreign_key "orders", "equipment"
end
