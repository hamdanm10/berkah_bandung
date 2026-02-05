class CreateOrderItemReservedDetails < ActiveRecord::Migration[8.1]
  def change
    create_table :order_item_reserved_details do |t|
      t.references :order_item, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
