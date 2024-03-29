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

ActiveRecord::Schema.define(version: 20170823115400) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer "selector"
    t.string "place"
    t.string "time"
    t.bigint "registration_data_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_data_id"], name: "index_games_on_registration_data_id"
  end

  create_table "registration_data", force: :cascade do |t|
    t.string "date"
    t.string "team_name"
    t.string "status"
    t.integer "member_amount"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "secret"
    t.index ["user_id"], name: "index_registration_data_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "telegram_id"
    t.string "first_name"
    t.string "last_name"
    t.jsonb "bot_command_data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.string "secret"
    t.string "phone_number"
    t.string "team_name"
  end

end
