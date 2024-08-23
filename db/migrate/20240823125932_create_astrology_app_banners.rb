class CreateAstrologyAppBanners < ActiveRecord::Migration[7.1]
  def change
    create_table :astrology_app_banners do |t|
      t.string :title
      t.string :action_url
      t.string :img_url
      t.boolean :status,default: false

      t.timestamps
    end
  end
end
