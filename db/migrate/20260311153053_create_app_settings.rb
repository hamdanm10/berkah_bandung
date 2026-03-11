class CreateAppSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :app_settings do |t|
      t.datetime :last_stock_check, null: false

      t.timestamps
    end
  end
end
