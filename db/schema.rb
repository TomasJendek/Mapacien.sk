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

ActiveRecord::Schema.define(version: 20141220154241) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "properties", force: true do |t|
    t.integer  "floor"
    t.integer  "total_floors"
    t.integer  "area"
    t.integer  "price"
    t.integer  "price_m2"
    t.text     "original_url"
    t.integer  "num_of_room_cd"
    t.integer  "property_type_cd"
    t.integer  "state_type_cd"
    t.integer  "property_category_cd"
    t.integer  "country_cd"
    t.decimal  "latitude",             precision: 10, scale: 7
    t.decimal  "longitude",            precision: 10, scale: 7
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
