class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :image_url
      t.float :price
      t.integer :discount
      t.integer :no_of_items
      t.text :description
      t.boolean :status
      t.references :shopit_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
