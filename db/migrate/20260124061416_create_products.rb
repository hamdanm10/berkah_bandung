class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string  :code, null: false
      t.string  :barcode, null: false
      t.string  :name, null: false

      t.references :category, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true

      t.boolean :is_active, null: false, default: true

      t.timestamp :deleted_at, null: true

      t.timestamps
    end

    add_index :products, :code, unique: true
    add_index :products, :barcode, unique: true
    add_index :products, :deleted_at
  end
end
