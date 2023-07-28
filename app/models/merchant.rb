class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices, through: :items

  def distinct_invoices
    invoices.distinct
  end

  def item_shipped_status
      Item.joins(:invoice_items)
        .where(invoice_items: {status: ['pending','packaged']})
        .where('merchant_id = ?', "#{id}")
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