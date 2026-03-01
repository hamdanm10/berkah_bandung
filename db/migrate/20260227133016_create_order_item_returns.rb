class CreateOrderItemReturns < ActiveRecord::Migration[8.1]
  def change
    create_table :order_item_returns do |t|
      t.references :order_item, null: false, foreign_key: true
      t.integer :good_stock, null: false
      t.integer :bad_stock, null: false

      t.timestamps
    end
  end
end
