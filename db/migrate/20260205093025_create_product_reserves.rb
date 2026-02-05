class CreateProductReserves < ActiveRecord::Migration[8.1]
  def change
    create_table :product_reserves do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 0

      t.timestamps
    end
  end
end
