class CreateShopitCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :shopit_categories do |t|
      t.string :name
      t.text :image_url
      t.boolean :status

      t.timestamps
    end
  end
end
