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

ActiveRecord::Schema.define(version: 20160408202923) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.string   "city"
    t.string   "street"
    t.string   "apt"
    t.string   "state"
    t.string   "zip"
    t.string   "address_type"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "addresses", ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", using: :btree

  create_table "amenities", force: :cascade do |t|
    t.string   "amenity_type"
    t.boolean  "active",       default: true
    t.string   "name"
    t.string   "description"
    t.boolean  "extended_int", default: true
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "amenities_vehicles", id: false, force: :cascade do |t|
    t.integer "amenity_id"
    t.integer "vehicle_id"
  end

  add_index "amenities_vehicles", ["amenity_id"], name: "index_amenities_vehicles_on_amenity_id", using: :btree
  add_index "amenities_vehicles", ["vehicle_id"], name: "index_amenities_vehicles_on_vehicle_id", using: :btree

  create_table "bookings", force: :cascade do |t|
    t.date     "check_in"
    t.date     "check_out"
    t.float    "total_amount"
    t.float    "rental_amount"
    t.float    "service_fee"
    t.string   "state"
    t.integer  "user_id"
    t.integer  "owner_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "vehicle_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "photos", ["vehicle_id"], name: "index_photos_on_vehicle_id", using: :btree

  create_table "prices", force: :cascade do |t|
    t.integer  "vehicle_id"
    t.integer  "nightly_amount", default: 0
    t.integer  "special_amount", default: 0
    t.integer  "weekly_amount",  default: 0
    t.integer  "monthly_amount", default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "prices", ["vehicle_id"], name: "index_prices_on_vehicle_id", using: :btree

  create_table "reservations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "vehicle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "on_date"
    t.string   "state"
    t.integer  "booking_id"
  end

  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id", using: :btree
  add_index "reservations", ["vehicle_id"], name: "index_reservations_on_vehicle_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "phone_number"
    t.text     "description"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vehicles", force: :cascade do |t|
    t.string   "vehicle_type"
    t.integer  "accommodates"
    t.text     "summary"
    t.boolean  "active"
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "listing_name"
    t.integer  "minimum_stay", default: 1
  end

  add_index "vehicles", ["user_id"], name: "index_vehicles_on_user_id", using: :btree

  add_foreign_key "photos", "vehicles"
  add_foreign_key "prices", "vehicles"
  add_foreign_key "reservations", "users"
  add_foreign_key "reservations", "vehicles"
  add_foreign_key "vehicles", "users"
end
