class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.string :title, null: false
      t.text :message, null: false
      t.string :notification_type, null: false
      t.references :notifiable, polymorphic: true, null: true, index: true
      t.datetime :read_at, null: true

      t.timestamps
    end

    add_index :notifications, :notification_type
    add_index :notifications, :read_at
  end
end
