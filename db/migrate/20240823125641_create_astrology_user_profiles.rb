class CreateAstrologyUserProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :astrology_user_profiles do |t|
      t.string :name
      t.string :gender
      t.string :date_of_birth
      t.string :location
      t.references :astrology_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
