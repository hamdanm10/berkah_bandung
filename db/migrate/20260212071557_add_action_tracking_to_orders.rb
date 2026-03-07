class AddActionTrackingToOrders < ActiveRecord::Migration[8.1]
  def change
    add_reference :orders, :paid_by, foreign_key: { to_table: :users }, null: true
    add_column :orders, :paid_at, :datetime

    add_reference :orders, :delivered_by, foreign_key: { to_table: :users }, null: true
    add_column :orders, :delivered_at, :datetime

    add_reference :orders, :cancelled_by, foreign_key: { to_table: :users }, null: true
    add_column :orders, :cancelled_at, :datetime

    add_reference :orders, :returned_by, foreign_key: { to_table: :users }, null: true
    add_column :orders, :returned_at, :datetime

    add_index :orders, :paid_at
    add_index :orders, :delivered_at
    add_index :orders, :cancelled_at
    add_index :orders, :returned_at

    add_index :orders, %i[deleted_at created_at]
    add_index :orders, %i[deleted_at status]
  end
end
