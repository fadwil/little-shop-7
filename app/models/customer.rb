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
end