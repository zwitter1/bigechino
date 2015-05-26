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

ActiveRecord::Schema.define(version: 0) do

  create_table "audit", primary_key: "headid", force: true do |t|
    t.boolean "edited",             default: false
    t.string  "changed", limit: 60
  end

  create_table "foreigndb", force: true do |t|
    t.string "description", limit: 300, null: false
    t.string "dbname",      limit: 16,  null: false
  end

  create_table "foreigndb_link", id: false, force: true do |t|
    t.string "header", limit: 60, null: false
    t.string "id",     limit: 24, null: false
  end

  add_index "foreigndb_link", ["id"], name: "id", using: :btree

  create_table "goterm", force: true do |t|
    t.string  "root",            limit: 15
    t.string  "namespace",       limit: 30
    t.string  "name",            limit: 200
    t.integer "level"
    t.string  "def",             limit: 2000
    t.text    "contains",        limit: 2147483647
    t.string  "is_a",            limit: 200
    t.string  "part_of",         limit: 200
    t.string  "regulates",       limit: 200
    t.string  "pos_regulates",   limit: 200
    t.string  "neg_regulates",   limit: 200
    t.text    "synonym",         limit: 2147483647
    t.date    "creation_date"
    t.string  "created_by",      limit: 30
    t.string  "intersection_of", limit: 200
    t.string  "subset",          limit: 200
    t.text    "dbxref",          limit: 2147483647
    t.string  "comment",         limit: 2000
    t.string  "alt_id",          limit: 2000
    t.binary  "is_obsolete",     limit: 1
    t.string  "consider",        limit: 200
    t.string  "replaced_by",     limit: 200
    t.string  "has_part",        limit: 200
    t.string  "occurs_in",       limit: 200
    t.string  "disjoint_from",   limit: 200
    t.string  "property_value",  limit: 200
    t.string  "happens_during",  limit: 200
  end

  create_table "goterm_link", id: false, force: true do |t|
    t.string "header", limit: 60, null: false
    t.string "id",     limit: 15, null: false
  end

  add_index "goterm_link", ["id"], name: "id", using: :btree

  create_table "sequences", primary_key: "header", force: true do |t|
    t.text    "protein_sequence", limit: 2147483647
    t.text    "coding_sequence",  limit: 2147483647
    t.text    "raw_nucleotide",   limit: 2147483647
    t.integer "read_depth"
    t.string  "header_id",        limit: 30
    t.string  "header_char",      limit: 5
    t.integer "header_loc"
    t.integer "taxa_id",                             null: false
    t.string  "interpro_id",      limit: 15
    t.string  "interpro_desc",    limit: 300
    t.string  "raw_header",       limit: 60
    t.string  "key_header",       limit: 60
    t.date    "date"
    t.string  "hex",              limit: 32
    t.integer "num1"
    t.integer "num2"
    t.integer "num3"
    t.float   "float1",           limit: 24
    t.string  "char1",            limit: 1
  end

  add_index "sequences", ["taxa_id"], name: "taxa_id", using: :btree

  create_table "taxa", force: true do |t|
    t.string "class", limit: 60, null: false
    t.string "genus", limit: 60, null: false
  end

end
