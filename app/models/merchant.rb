class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices, through: :items

  def distinct_invoices
    invoices.distinct
  end

  def items_sold_in_invoice(invoice_id)
    items.joins(:invoices).where('invoices.id = ?', invoice_id)
  end

  def total_revenue_for_invoice(invoice_id)
    items_sold_in_invoice(invoice_id)
      .joins(:invoice_items)
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end

  # def top_items
  #   items.order("total_revenue DESC").limit(5)
  # end
end