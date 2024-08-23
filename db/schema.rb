# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_23_125932) do
  create_table "app_banners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "image_url"
    t.string "action_url"
    t.boolean "status"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "app_opens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "source_ip"
    t.string "version_name"
    t.string "version_code"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_app_opens_on_user_id"
  end

  create_table "articles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "content"
    t.string "image_url"
    t.string "video_url"
    t.string "author"
    t.string "published_at"
    t.string "source_url"
    t.boolean "status", default: true
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_articles_on_category_id"
  end

  create_table "astrologies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "description"
    t.string "compatibility"
    t.string "color"
    t.string "lucky_number"
    t.string "lucky_time"
    t.string "date_range"
    t.string "current_date"
    t.string "mood"
    t.integer "sign"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "astrology_app_banners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.string "action_url"
    t.string "img_url"
    t.boolean "status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "astrology_appopens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "version_name"
    t.string "version_code"
    t.string "location"
    t.string "source_ip"
    t.bigint "astrology_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["astrology_user_id"], name: "index_astrology_appopens_on_astrology_user_id"
  end

  create_table "astrology_user_profiles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "gender"
    t.string "date_of_birth"
    t.string "location"
    t.bigint "astrology_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["astrology_user_id"], name: "index_astrology_user_profiles_on_astrology_user_id"
  end

  create_table "astrology_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "social_id"
    t.text "social_token"
    t.string "social_type"
    t.string "social_imgurl"
    t.string "social_email"
    t.string "social_name"
    t.string "mobile_number"
    t.string "device_id"
    t.string "device_type"
    t.string "device_name"
    t.string "security_token"
    t.string "advertising_id"
    t.string "referral_code"
    t.string "version_name"
    t.string "version_code"
    t.string "location"
    t.string "source_ip"
    t.text "fcm_token"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "utm_gclid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "product_id"
    t.integer "shopit_user_id"
    t.integer "no_of_products"
    t.integer "checkout_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.boolean "status", default: true
    t.string "image_url"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "checkouts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "mobile"
    t.string "address"
    t.string "shipping"
    t.string "comment"
    t.string "order_status", default: "ORDERED"
    t.string "order_id"
    t.integer "shopit_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ft_app_opens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "source_ip"
    t.string "version_name"
    t.string "version_code"
    t.bigint "ft_app_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ft_app_user_id"], name: "index_ft_app_opens_on_ft_app_user_id"
  end

  create_table "ft_app_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "device_id"
    t.string "device_type"
    t.string "device_name"
    t.string "social_type"
    t.string "social_id"
    t.string "social_name"
    t.string "social_email"
    t.string "social_img_url"
    t.string "advertising_id"
    t.string "version_name"
    t.string "version_code"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "source_ip"
    t.string "referrer_url"
    t.string "security_token"
    t.string "refer_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "product_id"
    t.string "shopit_user_id"
    t.string "no_of_products"
    t.string "checkout_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "image_url"
    t.float "price"
    t.integer "discount"
    t.integer "no_of_items"
    t.text "description"
    t.boolean "status"
    t.bigint "shopit_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shopit_category_id"], name: "index_products_on_shopit_category_id"
  end

  create_table "saveds", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "article_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_saveds_on_article_id"
    t.index ["user_id"], name: "index_saveds_on_user_id"
  end

  create_table "shopit_app_opens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "shopit_user_id", null: false
    t.string "version_name"
    t.string "version_code"
    t.string "source_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shopit_user_id"], name: "index_shopit_app_opens_on_shopit_user_id"
  end

  create_table "shopit_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "image_url"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shopit_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "device_id"
    t.string "device_type"
    t.string "device_name"
    t.string "advertising_id"
    t.string "social_name"
    t.string "social_type"
    t.string "social_id"
    t.string "social_email"
    t.string "social_img_url"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_content"
    t.string "utm_term"
    t.string "version_name"
    t.string "version_code"
    t.string "source_ip"
    t.string "utm_campaign"
    t.string "referrer_url"
    t.string "security_token"
    t.string "refer_code"
    t.string "mobile_number"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "device_id"
    t.string "device_type"
    t.string "device_name"
    t.string "social_type"
    t.string "social_id"
    t.string "social_name"
    t.string "social_email"
    t.string "social_img_url"
    t.string "advertising_id"
    t.string "version_name"
    t.string "version_code"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "source_ip"
    t.string "referrer_url"
    t.string "security_token"
    t.string "refer_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_from"
  end

  add_foreign_key "articles", "categories"
  add_foreign_key "astrology_appopens", "astrology_users"
  add_foreign_key "astrology_user_profiles", "astrology_users"
  add_foreign_key "products", "shopit_categories"
  add_foreign_key "saveds", "articles"
  add_foreign_key "saveds", "users"
  add_foreign_key "shopit_app_opens", "shopit_users"
end
