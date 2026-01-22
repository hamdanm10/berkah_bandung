class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :avatar, null: true
      t.string :full_name, null: false
      t.string :username, null: false
      t.string :password_digest, null: false
      t.integer :role, null: false
      t.boolean :is_active, null: false, default: :true

      t.timestamps
    end
    add_index :users, :username, unique: true
  end
end
