class CreateCourierServices < ActiveRecord::Migration[8.1]
  def change
    create_table :courier_services do |t|
      t.string :name, null: false
      t.boolean :is_active, null: false, default: true
      t.timestamp :deleted_at, null: true

      t.timestamps
    end

    add_index :courier_services, :deleted_at
  end
end
