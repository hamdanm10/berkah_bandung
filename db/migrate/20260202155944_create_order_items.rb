class CreateOrderItems < ActiveRecord::Migration[8.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false
      t.references :product, null: false

      t.string  :product_name, null: false
      t.string  :product_code, null: false
      t.string  :product_variant, null: true

      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
