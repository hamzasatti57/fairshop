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

ActiveRecord::Schema.define(version: 2019_09_12_132119) do

  create_table "pictures", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "picture_name"
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable_type_and_imageable_id"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "product_name"
    t.string "product_category"
    t.string "product_brand"
    t.string "product_model"
    t.string "product_warranty"
    t.string "product_color"
    t.boolean "product_isview"
    t.boolean "product_sale_status"
    t.integer "product_purchase_price"
    t.integer "product_sale_price"
    t.boolean "product_cash_on_delivery"
    t.boolean "product_home_delivery"
    t.integer "product_return_days"
    t.integer "product_discount"
    t.string "product_material"
    t.integer "product_quantity"
    t.bigint "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_products_on_store_id"
  end

  create_table "stores", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "store_name"
    t.string "store_city"
    t.string "store_address"
    t.string "store_country"
    t.string "store_state"
    t.string "store_area"
    t.string "store_map_link"
    t.boolean "stroe_active"
    t.time "store_on_time"
    t.time "store_close_time"
    t.bigint "vender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vender_id"], name: "index_stores_on_vender_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "venders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "city"
    t.string "address"
    t.string "gender"
    t.date "dob"
    t.string "cnic"
    t.string "contact"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "products", "stores"
  add_foreign_key "stores", "venders"
end
