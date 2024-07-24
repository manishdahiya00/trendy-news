class CreateAppBanners < ActiveRecord::Migration[7.1]
  def change
    create_table :app_banners do |t|
      t.string :image_url
      t.string :action_url
      t.boolean :status
      t.string :title

      t.timestamps
    end
  end
end
