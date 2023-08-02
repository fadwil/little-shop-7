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

  def items_status
      Item.joins(invoice_items: [:invoice])
        .where(invoice_items: {status: ['pending','packaged']})
        .where('merchant_id = ?', "#{id}")
        .select('items.*, invoice_items.invoice_id AS invoice_id, invoices.created_at AS invoice_created')
        .group(:invoice_id, :id, :item_id, :invoice_created)
        .order('invoice_created ASC')
  end

  def top_customers
    Customer.joins(invoices: [:invoice_items, :transactions, :items])
      .where(items: { merchant_id: id}, transactions: { result: 'success'})
      .select('customers.*, COUNT(transactions.id) AS successful_transactions_count')
      .group(:id)
      .order('successful_transactions_count DESC')
      .limit(5)
  end
  
  def items_sold_in_invoice(invoice_id)
    items.joins(:invoices).where('invoices.id = ?', invoice_id)
  end

  def total_revenue_for_invoice(invoice_id)
    items_sold_in_invoice(invoice_id)
      .joins(:invoice_items)
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def top_items
    items.joins(invoices: :transactions)
    .where(transactions: { result: 'success' })
    .group('items.id')
    .select('items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
    .order('total_revenue DESC')
    .limit(5)
  end

end