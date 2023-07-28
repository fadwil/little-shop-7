class Customer < ApplicationRecord
  has_many :invoices

  def self.top_customers_with_transactions
    Customer.joins(invoices: :transactions)
            .where(invoices: { status: 'completed' }, transactions: { result: 'success'})
            .select('customers.*, COUNT(transactions.id) as transaction_count')
            .group(:id)
            .order('COUNT(transactions.id) DESC')
            .limit(5)
  end

  def self.top_customers_for_merchant(merchant_id)
    joins(invoices: :transactions)
      .where(transactions: { result: 'success' })
      .where(items: { merchant_id: merchant_id })
      .select('customers.*, COUNT(transactions.id) AS successful_transactions_count')
      .group('customers.id')
      .order('successful_transactions_count DESC')
      .limit(5)
  end
end