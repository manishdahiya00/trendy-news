class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.integer :product_id
      t.integer :shopit_user_id
      t.integer :no_of_products
      t.integer :checkout_id

      t.timestamps
    end
  end
end
