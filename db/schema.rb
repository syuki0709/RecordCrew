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

ActiveRecord::Schema[7.2].define(version: 2024_11_24_134320) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "reservations", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "status"
    t.bigint "user_id", null: false
    t.bigint "studio_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["studio_id"], name: "index_reservations_on_studio_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "studio_availabilities", force: :cascade do |t|
    t.date "date", null: false
    t.string "day_of_week", null: false
    t.time "business_hour_start", null: false
    t.time "business_hour_end", null: false
    t.boolean "available_status", default: true, null: false
    t.bigint "studio_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["studio_id"], name: "index_studio_availabilities_on_studio_id"
  end

  create_table "studios", force: :cascade do |t|
    t.string "name", null: false
    t.string "address"
    t.string "email", null: false
    t.string "phone_number"
    t.string "nearest_station", null: false
    t.integer "hourly_rate", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "reservations", "studios"
  add_foreign_key "reservations", "users"
  add_foreign_key "studio_availabilities", "studios"
end
