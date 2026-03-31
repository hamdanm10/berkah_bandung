class CreateInvoiceItems < ActiveRecord::Migration[8.1]
  def change
    create_table :invoice_items do |t|
      t.references :invoice, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :variant, null: true
      t.integer :quantity, null: false
      t.references :product_available, null: false, foreign_key: true
      t.decimal :cost_snapshot, precision: 11, scale: 2, null: false

      t.timestamps
    end
  end
end
