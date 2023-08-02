class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices, through: :items
  enum status: {enabled: "Enabled", disabled: "Disabled"}

  def self.top_merchants_by_revenue
    Merchant.joins(invoices: [:transactions, :invoice_items])
            .where(transactions: { result: 'success' })
            .group(:id, :name)
            .select('merchants.id, merchants.name, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue')
            .order('revenue DESC')
            .limit(5)
  end

  def top_selling_date
    successful_invoice = invoices.joins(:transactions).find_by(transactions: { result: 'success' })
    successful_invoice&.created_at
  end

  def distinct_invoices
    invoices.distinct
  end
end