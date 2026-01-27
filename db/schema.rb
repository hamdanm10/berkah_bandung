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

ActiveRecord::Schema[8.1].define(version: 2026_01_26_071306) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "brands", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "is_active", default: true, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "is_active", default: true, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courier_services", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "is_active", default: true, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "distributors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "is_active", default: true, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.string "assigned_role", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "invitation_code", limit: 6, null: false
    t.boolean "is_used", default: false, null: false
    t.datetime "updated_at", null: false
    t.datetime "used_at"
    t.bigint "used_by_user_id"
    t.index ["invitation_code"], name: "index_invitations_on_invitation_code", unique: true
    t.index ["used_by_user_id"], name: "index_invitations_on_used_by_user_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "distributor_id", null: false
    t.decimal "entered_amount", precision: 15, scale: 2, null: false
    t.string "invoice", null: false
    t.decimal "invoice_amount", precision: 15, scale: 2
    t.string "invoice_number", null: false
    t.integer "invoice_status", null: false
    t.integer "invoice_type", null: false
    t.date "received_date"
    t.bigint "reference_invoice_id"
    t.text "remarks"
    t.decimal "total_transfer_amount", precision: 15, scale: 2
    t.decimal "transfer_amount", precision: 15, scale: 2
    t.date "transfer_date"
    t.datetime "updated_at", null: false
    t.index ["distributor_id"], name: "index_invoices_on_distributor_id"
    t.index ["reference_invoice_id"], name: "index_invoices_on_reference_invoice_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "is_active", default: true, null: false
    t.string "marketplace", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_prices", force: :cascade do |t|
    t.decimal "cost_price", precision: 11, scale: 2, null: false
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_prices_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "barcode", null: false
    t.bigint "brand_id", null: false
    t.bigint "category_id", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "is_active", default: true, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.string "variant"
    t.index ["barcode"], name: "index_products_on_barcode", unique: true
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["code"], name: "index_products_on_code", unique: true
    t.index ["deleted_at"], name: "index_products_on_deleted_at"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar"
    t.datetime "created_at", null: false
    t.string "full_name", null: false
    t.boolean "is_active", default: true, null: false
    t.string "password_digest", null: false
    t.integer "role", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "invitations", "users", column: "used_by_user_id"
  add_foreign_key "invoices", "distributors"
  add_foreign_key "invoices", "invoices", column: "reference_invoice_id"
  add_foreign_key "product_prices", "products"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "categories"
  add_foreign_key "sessions", "users"
end
