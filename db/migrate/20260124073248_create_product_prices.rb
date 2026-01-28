class CreateProductPrices < ActiveRecord::Migration[8.1]
  def change
    create_table :product_prices do |t|
      t.references :product, null: false, foreign_key: true

      t.integer :quantity, null: false
      t.decimal :cost_price, precision: 11, scale: 2, null: false

      t.timestamps
    end

    add_index :product_prices, [ :product_id, :cost_price ], unique: true
  end
end
