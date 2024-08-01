class CreateFtAppOpens < ActiveRecord::Migration[7.1]
  def change
    create_table :ft_app_opens do |t|
      t.string :source_ip
      t.string :version_name
      t.string :version_code
      t.references :ft_app_user
      t.timestamps
    end
  end
end
