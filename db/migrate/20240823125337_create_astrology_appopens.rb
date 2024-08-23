class CreateAstrologyAppopens < ActiveRecord::Migration[7.1]
  def change
    create_table :astrology_appopens do |t|
      t.string :version_name
      t.string :version_code
      t.string :location
      t.string :source_ip
      t.references :astrology_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
