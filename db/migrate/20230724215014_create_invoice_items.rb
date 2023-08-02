class CreateInvoiceItems < ActiveRecord::Migration[7.0]
  def change
    create_table :invoice_items do |t|
      t.integer :quantity
      t.integer :unit_price
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
