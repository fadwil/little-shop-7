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

  def top_selling_date
    invoices.joins(invoice_items: :item)
      .where(items: { id: id })
      .group('DATE(invoices.created_at), invoices.id, invoices.status, invoices.created_at, invoices.updated_at, invoices.customer_id')
      .select('invoices.*, SUM(invoice_items.quantity) AS number_sold')
      .order('number_sold DESC')
      .limit(1)
      .first
  end
end