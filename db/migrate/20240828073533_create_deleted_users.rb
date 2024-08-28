class CreateDeletedUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :deleted_users do |t|
      t.string :from
      t.string :email

      t.timestamps
    end
  end
end
