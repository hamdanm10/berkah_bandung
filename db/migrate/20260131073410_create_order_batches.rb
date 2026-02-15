class CreateOrderBatches < ActiveRecord::Migration[8.1]
  def change
    create_table :order_batches do |t|
      t.string :code, null: false
      t.references :merchant, null: false, foreign_key: true
      t.references :created_by_user, foreign_key: { to_table: :users }, null: false
      t.timestamp :deleted_at, null: true

      t.timestamps
    end

    add_index :order_batches, :deleted_at
  end
end
