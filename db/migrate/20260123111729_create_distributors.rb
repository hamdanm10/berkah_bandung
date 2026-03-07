class CreateDistributors < ActiveRecord::Migration[8.1]
  def change
    create_table :distributors do |t|
      t.string :name, null: false
      t.boolean :is_active, null: false, default: true
      t.timestamp :deleted_at, null: true

      t.timestamps
    end

    add_index :distributors, :deleted_at
  end
end
