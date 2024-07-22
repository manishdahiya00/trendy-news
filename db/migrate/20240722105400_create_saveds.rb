class CreateSaveds < ActiveRecord::Migration[7.1]
  def change
    create_table :saveds do |t|
      t.references :user, null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true

      t.timestamps
    end
  end
end
