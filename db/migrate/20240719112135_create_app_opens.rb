class CreateAppOpens < ActiveRecord::Migration[7.1]
  def change
    create_table :app_opens do |t|
      t.string :source_ip
      t.string :version_name
      t.string :version_code
      t.references :user

      t.timestamps
    end
  end
end
