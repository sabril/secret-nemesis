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

ActiveRecord::Schema.define(:version => 20120623012922) do

  create_table "patents", :force => true do |t|
    t.integer  "application_number"
    t.string   "application_type"
    t.string   "application_status"
    t.string   "under_opposition"
    t.string   "proceeding_type"
    t.string   "invention_title"
    t.string   "inventor"
    t.string   "agent_name"
    t.string   "address_for_service"
    t.string   "filing_date"
    t.string   "associated_companies"
    t.string   "applicant_name"
    t.string   "applicant_address"
    t.string   "old_name"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

end
