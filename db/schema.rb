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

ActiveRecord::Schema.define(:version => 20110603200544) do

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "daily_menus", :force => true do |t|
    t.integer  "menu_id"
    t.integer  "updated_by"
    t.integer  "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "daily_selections", :force => true do |t|
    t.integer  "menu_type_one_id"
    t.integer  "menu_type_two_id"
    t.integer  "menu_type_three_id"
    t.integer  "updated_by"
    t.integer  "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drop_off_location_times", :force => true do |t|
    t.time     "delivery_time"
    t.integer  "drop_off_location_id"
    t.string   "meal_service"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.time     "last_order_time"
  end

  create_table "drop_off_locations", :force => true do |t|
    t.string   "name"
    t.string   "street_address"
    t.string   "city"
    t.string   "map_url"
    t.string   "state"
    t.integer  "occupancy"
    t.integer  "square_feet"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location_type"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.integer  "category"
    t.integer  "calories"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "item_type"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "location_recipients", :force => true do |t|
    t.integer  "user_id"
    t.integer  "drop_off_location_id"
    t.string   "recipient_first_name"
    t.string   "recipient_last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number_area_code"
    t.string   "phone_number_prefix"
    t.string   "phone_number_suffix"
    t.string   "customer_type"
    t.integer  "meals_remaining"
  end

  create_table "location_selections", :force => true do |t|
    t.integer  "delivery_date_time"
    t.integer  "menu_id"
    t.integer  "drop_off_location_time_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meal_orders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "drop_off_location_id"
    t.integer  "meal_one_quantity",          :default => 0
    t.integer  "meal_two_quantity",          :default => 0
    t.integer  "meal_three_quantity",        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "delivery_date"
    t.boolean  "delivered",                  :default => false
    t.boolean  "confirmed",                  :default => false
    t.integer  "location_selection_id"
    t.integer  "user_order_confirmation_id"
  end

  create_table "meal_types", :force => true do |t|
    t.integer  "meal_type_id"
    t.string   "meal_type_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_items", :force => true do |t|
    t.integer  "menu_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "meal_type"
    t.integer  "vendor_id"
    t.integer  "price"
  end

  create_table "order_transactions", :force => true do |t|
    t.integer  "order_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "service_plan_id"
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "card_type"
    t.date     "card_expires_on"
    t.string   "billing_address"
    t.integer  "zip"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "express_token"
    t.string   "express_payer_id"
  end

  create_table "recipient_regular_schedules", :force => true do |t|
    t.integer  "location_recipient_id"
    t.boolean  "monday_scheduled"
    t.boolean  "tuesday_scheduled"
    t.boolean  "wednesday_scheduled"
    t.boolean  "thursday_scheduled"
    t.boolean  "friday_scheduled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipient_temporary_schedules", :force => true do |t|
    t.integer  "location_recipient_id"
    t.boolean  "monday_scheduled"
    t.boolean  "tuesday_scheduled"
    t.boolean  "wednesday_scheduled"
    t.boolean  "thursday_scheduled"
    t.boolean  "friday_scheduled"
    t.boolean  "monday_delivered"
    t.boolean  "tuesday_delivered"
    t.boolean  "wednesday_delivered"
    t.boolean  "thursday_delivered"
    t.boolean  "friday_delivered"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_plans", :force => true do |t|
    t.string   "name"
    t.string   "service_name_proper"
    t.decimal  "price",               :precision => 10, :scale => 2
    t.integer  "meals_included"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "states", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_drop_off_locations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "drop_off_location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_order_confirmations", :force => true do |t|
    t.integer  "user_id"
    t.date     "delivery_date"
    t.integer  "location_selection_id"
    t.boolean  "confirmed",                 :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "drop_off_location_time_id"
  end

  create_table "user_regular_schedules", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "monday_scheduled"
    t.boolean  "tuesday_scheduled"
    t.boolean  "wednesday_scheduled"
    t.boolean  "thursday_scheduled"
    t.boolean  "friday_scheduled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_service_plans", :force => true do |t|
    t.integer  "user_id"
    t.integer  "service_plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_recipient_id"
  end

  create_table "user_temporary_schedules", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "monday_scheduled"
    t.boolean  "tuesday_scheduled"
    t.boolean  "wednesday_scheduled"
    t.boolean  "thursday_scheduled"
    t.boolean  "friday_scheduled"
    t.boolean  "monday_delivered"
    t.boolean  "tuesday_delivered"
    t.boolean  "wednesday_delivered"
    t.boolean  "thursday_delivered"
    t.boolean  "friday_delivered"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                  :default => "", :null => false
    t.string   "encrypted_password",      :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "drop_off_location_id"
    t.string   "phone_number_area_code"
    t.string   "phone_number_prefix"
    t.string   "phone_number_suffix"
    t.integer  "meals_remaining",                        :default => 0
    t.integer  "admin",                                  :default => 0
    t.integer  "total_credits_purchased",                :default => 0
    t.integer  "total_credits_used",                     :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vendor_profiles", :force => true do |t|
    t.integer  "vendor_id"
    t.string   "intro"
    t.string   "description"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "map_url"
  end

  create_table "vendors", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "city_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

end
