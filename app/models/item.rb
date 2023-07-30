class Item < ApplicationRecord
  belongs_to :merchant 
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  enum status: {
    "disabled" => 0,
    "enabled" => 1
  }

  def total_revenue
    invoice_items.joins(invoice: :transactions)
                .where('transactions.result' => 'success')
                .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end