class CreateInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :invitations do |t|
      t.string :invitation_code, limit: 6, null: false
      t.string :assigned_role, null: false
      t.boolean :is_used, null: false, default: false
      t.references :used_by_user, foreign_key: { to_table: :users }, null: true
      t.datetime :used_at, null: true
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :invitations, :invitation_code, unique: true
  end
end
