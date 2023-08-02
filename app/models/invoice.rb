class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  enum status: { cancelled: "Cancelled", completed: "Completed", in_progress: "In Progress"}


  def self.unshipped_invoices
    Invoice.joins(:invoice_items).where.not(invoice_items: { status: 'shipped' }).distinct.order(:created_at)
  end

  def format_created_at
    created_at.strftime("%A, %B %d, %Y")
  end

end