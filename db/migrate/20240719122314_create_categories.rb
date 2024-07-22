class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.boolean :status, default: true
      t.string :image_url
      t.string :color

      t.timestamps
    end
  end
end
