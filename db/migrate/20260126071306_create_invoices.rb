class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices do |t|
      t.references :distributor, null: false, foreign_key: true
      t.string :invoice, null: false
      t.decimal :entered_amount, precision: 15, scale: 2, null: false
      t.decimal :invoice_amount, precision: 15, scale: 2, null: true
      t.string :invoice_number, null: false
      t.date :received_date, null: true
      t.decimal :transfer_amount, precision: 15, scale: 2, null: true
      t.decimal :total_transfer_amount, precision: 15, scale: 2, null: true
      t.date :transfer_date, null: true
      t.text :remarks, null: true
      t.integer :invoice_status, null: false
      t.integer :invoice_type, null: false
      t.references :reference_invoice, foreign_key: { to_table: :invoices }, null: true

      t.timestamps
    end
  end
end
