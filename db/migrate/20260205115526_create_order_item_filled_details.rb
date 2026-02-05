class CreateOrderItemFilledDetails < ActiveRecord::Migration[8.1]
  def change
    create_table :order_item_filled_details do |t|
      t.references :order_item, null: false, foreign_key: true
      t.references :product_available, null: false, foreign_key: true
      t.references :order_item_reserved_detail, null: true, foreign_key: true
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
