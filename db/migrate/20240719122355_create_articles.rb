class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :description
      t.string :content
      t.string :image_url
      t.string :video_url
      t.string :author
      t.string :published_at
      t.string :source_url
      t.boolean :status, default: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
