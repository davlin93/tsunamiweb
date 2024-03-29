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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150211200119) do

  create_table "comments", :force => true do |t|
    t.integer  "wave_id"
    t.integer  "user_id"
    t.string   "body"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "social_profile_id"
  end

  create_table "contents", :force => true do |t|
    t.string  "caption"
    t.integer "wave_id"
    t.string  "type"
    t.string  "link"
  end

  create_table "ripples", :force => true do |t|
    t.decimal  "latitude",   :precision => 7, :scale => 4
    t.decimal  "longitude",  :precision => 7, :scale => 4
    t.decimal  "radius",     :precision => 7, :scale => 4
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "wave_id"
    t.integer  "user_id"
  end

  create_table "social_profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "service"
    t.string   "username"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "clicks",     :default => 0
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "viewed",     :default => 0
    t.string   "guid"
  end

  create_table "view_records", :force => true do |t|
    t.integer  "user_id"
    t.integer  "wave_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "waves", :force => true do |t|
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "origin_ripple_id"
    t.integer  "user_id"
    t.integer  "content_id"
    t.integer  "views",             :default => 0
    t.integer  "social_profile_id"
  end

  add_index "waves", ["user_id"], :name => "index_waves_on_user_id"

end
