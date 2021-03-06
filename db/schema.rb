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

ActiveRecord::Schema.define(version: 20140906102046) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: true do |t|
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "expires_at"
    t.string   "auth_token", null: false
  end

  add_index "authorizations", ["provider", "expires_at"], name: "index_authorizations_on_provider_and_expires_at", using: :btree
  add_index "authorizations", ["provider", "uid"], name: "index_authorizations_on_provider_and_uid", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name",           null: false
    t.string   "email",          null: false
    t.string   "nickname"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.float    "lat"
    t.float    "lon"
  end

  add_index "users", ["lat", "lon"], name: "index_users_on_lat_and_lon", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
