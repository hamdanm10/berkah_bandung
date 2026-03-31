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

ActiveRecord::Schema[8.1].define(version: 2026_03_31_113743) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "app_settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "last_stock_check", null: false
    t.datetime "updated_at", null: false
  end

  create_table "brands", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "is_active", default: true, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_brands_on_deleted_at"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "is_active", default: true, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_categories_on_deleted_at"
  end

  create_table "courier_services", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "is_active", default: true, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_courier_services_on_deleted_at"
  end

  create_table "distributor_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "distributor_id", null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["distributor_id", "product_id"], name: "index_distributor_items_on_distributor_and_product", unique: true
    t.index ["distributor_id"], name: "index_distributor_items_on_distributor_id"
    t.index ["product_id"], name: "index_distributor_items_on_product_id"
  end

  create_table "distributors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "is_active", default: true, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_distributors_on_deleted_at"
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

  create_table "invoice_items", force: :cascade do |t|
    t.decimal "cost_snapshot", precision: 11, scale: 2, null: false
    t.datetime "created_at", null: false
    t.bigint "invoice_id", null: false
    t.bigint "product_available_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.datetime "updated_at", null: false
    t.string "variant"
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
    t.index ["product_available_id"], name: "index_invoice_items_on_product_available_id"
    t.index ["product_id"], name: "index_invoice_items_on_product_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "created_by_user_id", null: false
    t.datetime "deleted_at", precision: nil
    t.bigint "distributor_id", null: false
    t.decimal "entered_amount", precision: 15, scale: 2, null: false
    t.string "invoice", null: false
    t.decimal "invoice_amount", precision: 15, scale: 2
    t.string "invoice_number", null: false
    t.integer "invoice_type", null: false
    t.date "received_date"
    t.text "remarks"
    t.decimal "total_transfer_amount", precision: 15, scale: 2
    t.decimal "transfer_amount", precision: 15, scale: 2
    t.date "transfer_date"
    t.datetime "updated_at", null: false
    t.index ["created_by_user_id"], name: "index_invoices_on_created_by_user_id"
    t.index ["distributor_id"], name: "index_invoices_on_distributor_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "is_active", default: true, null: false
    t.string "marketplace", null: false
    t.string "name", null: false
    t.string "scan_sound"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_merchants_on_deleted_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "message", null: false
    t.bigint "notifiable_id"
    t.string "notifiable_type"
    t.string "notification_type", null: false
    t.datetime "read_at"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["notification_type"], name: "index_notifications_on_notification_type"
    t.index ["read_at"], name: "index_notifications_on_read_at"
  end

  create_table "order_batches", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_user_id", null: false
    t.datetime "deleted_at", precision: nil
    t.bigint "merchant_id", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_user_id"], name: "index_order_batches_on_created_by_user_id"
    t.index ["deleted_at"], name: "index_order_batches_on_deleted_at"
    t.index ["merchant_id"], name: "index_order_batches_on_merchant_id"
  end

  create_table "order_item_filled_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "order_item_id", null: false
    t.bigint "product_available_id", null: false
    t.integer "quantity", null: false
    t.datetime "updated_at", null: false
    t.index ["order_item_id"], name: "index_order_item_filled_details_on_order_item_id"
    t.index ["product_available_id"], name: "index_order_item_filled_details_on_product_available_id"
  end

  create_table "order_item_returned_details", force: :cascade do |t|
    t.integer "bad_stock", null: false
    t.datetime "created_at", null: false
    t.integer "good_stock", null: false
    t.bigint "order_item_filled_detail_id", null: false
    t.bigint "order_item_return_id", null: false
    t.datetime "updated_at", null: false
    t.index ["order_item_filled_detail_id"], name: "idx_on_order_item_filled_detail_id_62657d3a68"
    t.index ["order_item_return_id"], name: "index_order_item_returned_details_on_order_item_return_id"
  end

  create_table "order_item_returns", force: :cascade do |t|
    t.integer "bad_stock", null: false
    t.datetime "created_at", null: false
    t.integer "good_stock", null: false
    t.bigint "order_item_id", null: false
    t.datetime "updated_at", null: false
    t.index ["order_item_id"], name: "index_order_item_returns_on_order_item_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "order_id", null: false
    t.string "product_code", null: false
    t.bigint "product_id", null: false
    t.string "product_name", null: false
    t.integer "quantity", null: false
    t.datetime "updated_at", null: false
    t.string "variant"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "cancelled_at"
    t.bigint "cancelled_by_id"
    t.bigint "courier_service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "delivered_at"
    t.bigint "delivered_by_id"
    t.bigint "order_batch_id", null: false
    t.string "order_number", null: false
    t.datetime "paid_at"
    t.bigint "paid_by_id"
    t.datetime "returned_at"
    t.bigint "returned_by_id"
    t.integer "status", null: false
    t.string "tracking_number", null: false
    t.datetime "updated_at", null: false
    t.index ["cancelled_at"], name: "index_orders_on_cancelled_at"
    t.index ["cancelled_by_id"], name: "index_orders_on_cancelled_by_id"
    t.index ["courier_service_id"], name: "index_orders_on_courier_service_id"
    t.index ["deleted_at", "created_at"], name: "index_orders_on_deleted_at_and_created_at"
    t.index ["deleted_at", "status"], name: "index_orders_on_deleted_at_and_status"
    t.index ["deleted_at"], name: "index_orders_on_deleted_at"
    t.index ["delivered_at"], name: "index_orders_on_delivered_at"
    t.index ["delivered_by_id"], name: "index_orders_on_delivered_by_id"
    t.index ["order_batch_id"], name: "index_orders_on_order_batch_id"
    t.index ["order_number"], name: "index_orders_on_order_number", unique: true
    t.index ["paid_at"], name: "index_orders_on_paid_at"
    t.index ["paid_by_id"], name: "index_orders_on_paid_by_id"
    t.index ["returned_at"], name: "index_orders_on_returned_at"
    t.index ["returned_by_id"], name: "index_orders_on_returned_by_id"
    t.index ["tracking_number"], name: "index_orders_on_tracking_number", unique: true
  end

  create_table "product_availables", force: :cascade do |t|
    t.decimal "cost_price", precision: 11, scale: 2, null: false
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_availables_on_product_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "distributor_items", "distributors"
  add_foreign_key "distributor_items", "products"
  add_foreign_key "invitations", "users", column: "used_by_user_id"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoice_items", "product_availables"
  add_foreign_key "invoice_items", "products"
  add_foreign_key "invoices", "distributors"
  add_foreign_key "invoices", "users", column: "created_by_user_id"
  add_foreign_key "order_batches", "merchants"
  add_foreign_key "order_batches", "users", column: "created_by_user_id"
  add_foreign_key "order_item_filled_details", "order_items"
  add_foreign_key "order_item_filled_details", "product_availables"
  add_foreign_key "order_item_returned_details", "order_item_filled_details"
  add_foreign_key "order_item_returned_details", "order_item_returns"
  add_foreign_key "order_item_returns", "order_items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "courier_services"
  add_foreign_key "orders", "order_batches"
  add_foreign_key "orders", "users", column: "cancelled_by_id"
  add_foreign_key "orders", "users", column: "delivered_by_id"
  add_foreign_key "orders", "users", column: "paid_by_id"
  add_foreign_key "orders", "users", column: "returned_by_id"
  add_foreign_key "product_availables", "products"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "categories"
  add_foreign_key "sessions", "users"
end
