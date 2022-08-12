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

ActiveRecord::Schema.define(version: 2022_08_12_053938) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
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
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "communications", force: :cascade do |t|
    t.string "topic", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "email_communications", force: :cascade do |t|
    t.string "sender", null: false
    t.string "recipient", null: false
    t.string "template_id", null: false
    t.json "template_data"
    t.bigint "communication_id", null: false
    t.string "target_type"
    t.bigint "target_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["communication_id"], name: "index_email_communications_on_communication_id"
    t.index ["target_type", "target_id"], name: "index_email_communications_on_target"
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_product_categories_on_slug", unique: true
  end

  create_table "product_contents", force: :cascade do |t|
    t.string "key", null: false
    t.text "value"
    t.bigint "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key", "product_id"], name: "index_product_contents_on_key_and_product_id", unique: true
    t.index ["key"], name: "index_product_contents_on_key"
    t.index ["product_id"], name: "index_product_contents_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.float "base_price", null: false
    t.boolean "featured", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_category_id", null: false
    t.index ["featured"], name: "index_products_on_featured"
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
    t.index ["slug"], name: "index_products_on_slug", unique: true
  end

  create_table "purchase_cart_extra_fees", force: :cascade do |t|
    t.bigint "purchase_cart_id", null: false
    t.string "key", null: false
    t.float "price", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key", "purchase_cart_id"], name: "index_purchase_cart_extra_fees_on_key_and_purchase_cart_id", unique: true
    t.index ["key"], name: "index_purchase_cart_extra_fees_on_key"
    t.index ["purchase_cart_id"], name: "index_purchase_cart_extra_fees_on_purchase_cart_id"
  end

  create_table "purchase_cart_items", force: :cascade do |t|
    t.bigint "purchase_cart_id", null: false
    t.bigint "stock_id", null: false
    t.integer "quantity", null: false
    t.float "unit_price", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uuid", null: false
    t.index ["purchase_cart_id"], name: "index_purchase_cart_items_on_purchase_cart_id"
    t.index ["stock_id"], name: "index_purchase_cart_items_on_stock_id"
    t.index ["uuid"], name: "index_purchase_cart_items_on_uuid", unique: true
  end

  create_table "purchase_carts", force: :cascade do |t|
    t.string "status", null: false
    t.float "total_price", null: false
    t.string "uuid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uuid"], name: "index_purchase_carts_on_uuid", unique: true
  end

  create_table "stock_toppings", force: :cascade do |t|
    t.bigint "topping_id", null: false
    t.bigint "stock_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stock_id"], name: "index_stock_toppings_on_stock_id"
    t.index ["topping_id", "stock_id"], name: "index_stock_toppings_on_topping_id_and_stock_id", unique: true
    t.index ["topping_id"], name: "index_stock_toppings_on_topping_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uuid", null: false
    t.index ["product_id"], name: "index_stocks_on_product_id"
    t.index ["uuid"], name: "index_stocks_on_uuid", unique: true
  end

  create_table "toppings", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "key", null: false
    t.string "value", null: false
    t.string "price_change"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key", "value", "product_id"], name: "index_toppings_on_key_and_value_and_product_id", unique: true
    t.index ["key"], name: "index_toppings_on_key"
    t.index ["product_id"], name: "index_toppings_on_product_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "verification_codes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "code_digest", null: false
    t.string "status", null: false
    t.datetime "expires_at", null: false
    t.string "expiration_job_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_verification_codes_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "email_communications", "communications"
  add_foreign_key "product_contents", "products"
  add_foreign_key "products", "product_categories"
  add_foreign_key "purchase_cart_extra_fees", "purchase_carts"
  add_foreign_key "purchase_cart_items", "purchase_carts"
  add_foreign_key "purchase_cart_items", "stocks"
  add_foreign_key "stock_toppings", "stocks"
  add_foreign_key "stock_toppings", "toppings"
  add_foreign_key "stocks", "products"
  add_foreign_key "toppings", "products"
  add_foreign_key "verification_codes", "users"
end
