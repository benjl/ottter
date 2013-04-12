class Heroku < ActiveRecord::Migration
  def up
  create_table "accidents" do |t|
    t.integer  "tid"
    t.string   "details"
    t.string   "time"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "sms_sent",   :default => false

 create_table "users" do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "street_dest"
    t.string   "street_orig"
    t.string   "path"
  end

  end

  def down
  end
end
