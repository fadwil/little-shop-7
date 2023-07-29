class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices, through: :items

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
end