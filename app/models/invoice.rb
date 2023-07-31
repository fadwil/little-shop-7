class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  enum status: { "in progress" => 0, "completed" => 1, "cancelled" => 2 }


  def self.unshipped_invoices
    Invoice.joins(:invoice_items).where.not(invoice_items: { status: 'shipped' }).distinct.order(:created_at)
  end

  def format_created_at
    created_at.strftime("%A, %B %d, %Y")
  end

  def transactions_successful?
    transactions.where(result: 'success').exists?
  end
end