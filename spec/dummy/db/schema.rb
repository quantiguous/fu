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

ActiveRecord::Schema.define(version: 20161219085000) do

  create_table "fm_audit_steps", force: :cascade do |t|
    t.string   "auditable_type",               null: false
    t.integer  "auditable_id",                 null: false
    t.integer  "step_no",                      null: false
    t.integer  "attempt_no",                   null: false
    t.string   "step_name",       limit: 100,  null: false
    t.string   "status_code",     limit: 25
    t.string   "fault_code",      limit: 50
    t.string   "fault_subcode",   limit: 50
    t.string   "fault_reason",    limit: 1000
    t.string   "req_reference",   limit: 255
    t.datetime "req_timestamp"
    t.string   "rep_reference"
    t.datetime "rep_timestamp"
    t.datetime "reconciled_at"
    t.text     "req_bitstream"
    t.text     "rep_bitstream"
    t.text     "fault_bitstream"
  end

  create_table "incoming_file_records", force: :cascade do |t|
    t.integer  "incoming_file_id"
    t.integer  "record_no"
    t.text     "record_txt"
    t.string   "status",              limit: 20
    t.string   "fault_code",          limit: 50
    t.string   "fault_subcode",       limit: 50
    t.string   "fault_reason",        limit: 1000
    t.datetime "created_at",                       null: false
    t.datetime "updated_at"
    t.text     "fault_bitstream"
    t.string   "rep_status",          limit: 50
    t.string   "rep_fault_code",      limit: 50
    t.string   "rep_fault_subcode",   limit: 50
    t.string   "rep_fault_reason",    limit: 500
    t.text     "rep_fault_bitstream"
    t.string   "overrides",           limit: 50
    t.integer  "attempt_no"
  end

  add_index "incoming_file_records", ["incoming_file_id", "record_no"], name: "in_file_records_1", unique: true

  create_table "incoming_file_types", force: :cascade do |t|
    t.integer "sc_service_id",                                 null: false
    t.string  "code",                limit: 50,                null: false
    t.string  "name",                limit: 50,                null: false
    t.string  "msg_domain",          limit: 255
    t.string  "msg_model",           limit: 255
    t.string  "validate_all",        limit: 1,   default: "N"
    t.string  "auto_upload",         limit: 1,   default: "N"
    t.string  "skip_first",          limit: 1,   default: "N"
    t.string  "build_response_file", limit: 1
    t.string  "correlation_field"
    t.string  "comment"
    t.string  "db_unit_name"
    t.string  "records_table"
    t.string  "can_override",        limit: 1,   default: "N", null: false
    t.string  "can_skip",            limit: 1,   default: "N", null: false
    t.string  "can_retry",           limit: 1,   default: "N", null: false
    t.string  "build_nack_file",     limit: 1,   default: "N", null: false
    t.string  "skip_last",           limit: 1,   default: "N", null: false
  end

  add_index "incoming_file_types", ["sc_service_id", "code"], name: "in_file_types_1", unique: true

  create_table "incoming_files", force: :cascade do |t|
    t.string   "service_name",               limit: 10
    t.string   "file_type",                  limit: 10
    t.string   "file"
    t.string   "file_name",                  limit: 100
    t.integer  "size_in_bytes"
    t.integer  "line_count"
    t.string   "status",                     limit: 1
    t.date     "started_at"
    t.date     "ended_at"
    t.string   "created_by",                 limit: 20
    t.string   "updated_by",                 limit: 20
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at"
    t.string   "fault_code",                 limit: 50
    t.string   "fault_subcode",              limit: 50
    t.string   "fault_reason",               limit: 1000
    t.string   "approval_status",            limit: 1,    default: "U", null: false
    t.string   "last_action",                limit: 1,    default: "C", null: false
    t.integer  "approved_version"
    t.integer  "approved_id"
    t.integer  "lock_version",                            default: 0,   null: false
    t.string   "broker_uuid",                limit: 255
    t.integer  "failed_record_count"
    t.string   "rep_file_name"
    t.string   "rep_file_path"
    t.string   "rep_file_status",            limit: 1
    t.string   "pending_approval",           limit: 1
    t.string   "file_path"
    t.string   "last_process_step",          limit: 1
    t.integer  "record_count"
    t.integer  "skipped_record_count"
    t.integer  "completed_record_count"
    t.integer  "timedout_record_count"
    t.integer  "alert_count"
    t.datetime "last_alert_at"
    t.integer  "bad_record_count"
    t.text     "fault_bitstream"
    t.integer  "pending_retry_record_count"
    t.integer  "overriden_record_count"
    t.string   "nack_file_name",             limit: 150
    t.string   "nack_file_path"
    t.string   "nack_file_status",           limit: 1
    t.text     "header_record"
  end

  add_index "incoming_files", ["file_name", "approval_status"], name: "in_incoming_files_1", unique: true
  add_index "incoming_files", ["service_name", "status", "pending_approval"], name: "in_incoming_files_2"

  create_table "sc_services", force: :cascade do |t|
    t.string "code", limit: 50, null: false
    t.string "name", limit: 50, null: false
  end

  add_index "sc_services", ["code"], name: "in_sc_services_1", unique: true
  add_index "sc_services", ["name"], name: "in_sc_services_2", unique: true

end
