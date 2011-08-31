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

ActiveRecord::Schema.define(:version => 20110831015544) do

  create_table "courses", :force => true do |t|
    t.string   "department"
    t.string   "department_abbr"
    t.integer  "oci_id"
    t.string   "number"
    t.string   "section"
    t.string   "title"
    t.string   "professor"
    t.text     "description"
    t.text     "prerequisites"
    t.string   "time_one_start"
    t.string   "time_one_end"
    t.string   "time_two_start"
    t.string   "time_two_end"
    t.string   "time_three_start"
    t.string   "time_three_end"
    t.string   "time_four_start"
    t.string   "time_four_end"
    t.string   "time_five_start"
    t.string   "time_five_end"
    t.string   "final_exam_time"
    t.string   "semester"
    t.boolean  "starred"
    t.boolean  "L1"
    t.boolean  "L2"
    t.boolean  "L3"
    t.boolean  "L4"
    t.boolean  "L5"
    t.boolean  "QR"
    t.boolean  "WR"
    t.boolean  "Hu"
    t.boolean  "Sc"
    t.boolean  "So"
    t.boolean  "readings_in_translation"
    t.boolean  "reading_period"
    t.string   "category"
    t.boolean  "cancelled"
    t.boolean  "gut"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "new"
    t.string   "room"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.text     "taking"
    t.text     "shopping"
    t.text     "avoiding"
    t.text     "taken"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "ical"
    t.string   "fb_id"
    t.string   "facebook_id"
  end

end
