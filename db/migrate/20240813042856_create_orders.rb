class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :product_id
      t.string :shopit_user_id
      t.string :no_of_products
      t.string :checkout_id

      t.timestamps
    end
  end
end
