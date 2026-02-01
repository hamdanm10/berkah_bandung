class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :order_batch, null: false, foreign_key: true
      t.references :courier_service, null: false, foreign_key: true
      t.string :order_number, null: false
      t.string :tracking_number, null: false
      t.timestamp :deleted_at, null: true

      t.timestamps
    end
  end
end
