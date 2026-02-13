class AddActionTrackingToOrders < ActiveRecord::Migration[8.1]
  def change
    add_reference :orders, :paid_by, foreign_key: { to_table: :users }, null: true
    add_column :orders, :paid_at, :timestamp, null: true

    add_reference :orders, :delivered_by, foreign_key: { to_table: :users }, null: true
    add_column :orders, :delivered_at, :timestamp, null: true

    add_reference :orders, :cancelled_by, foreign_key: { to_table: :users }, null: true
    add_column :orders, :cancelled_at, :timestamp, null: true

    add_reference :orders, :returned_by, foreign_key: { to_table: :users }, null: true
    add_column :orders, :returned_at, :timestamp, null: true
  end
end
