class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :order_batch, null: false, foreign_key: true
      t.references :courier_service, null: false, foreign_key: true
      t.string :order_number, null: false
      t.string :tracking_number, null: false
      t.integer :status, null: false
      t.timestamp :deleted_at, null: true

      t.timestamps
    end

    add_index :orders, :order_number, unique: true
    add_index :orders, :tracking_number, unique: true
    add_index :orders, :deleted_at
  end
end
