class AddUserFromInUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :user_from, :string
    change_column :articles, :description, :text
    change_column :articles, :content, :text
  end
end
