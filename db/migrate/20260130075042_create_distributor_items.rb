class CreateDistributorItems < ActiveRecord::Migration[8.1]
  def change
    create_table :distributor_items do |t|
      t.references :distributor, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end

    add_index :distributor_items,
              [ :distributor_id, :product_id ],
              unique: true,
              name: "index_distributor_items_on_distributor_and_product"
  end
end
