class CreateCheckouts < ActiveRecord::Migration[7.1]
  def change
    create_table :checkouts do |t|
      t.string :name
      t.string :email
      t.string :mobile
      t.string :address
      t.string :shipping
      t.string :comment
      t.string :order_status, default: "ORDERED"
      t.string :order_id
      t.integer :shopit_user_id

      t.timestamps
    end
  end
end
