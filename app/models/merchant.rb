class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices, through: :items

  def distinct_invoices
    invoices.distinct
  end

  def items_sold_in_invoice(invoice_id)
    items.joins(:invoices).where('invoices.id = ?', invoice_id)
  end
end