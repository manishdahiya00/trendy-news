class CreateAstrologies < ActiveRecord::Migration[7.1]
  def change
    create_table :astrologies do |t|
      t.text :description
      t.string :compatibility
      t.string :color
      t.string :lucky_number
      t.string :lucky_time
      t.string :date_range
      t.string :current_date
      t.string :mood
      t.integer :sign

      t.timestamps
    end
  end
end
