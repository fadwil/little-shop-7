class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  def self.for_merchant_invoice(merchant_id, invoice_id)
    joins(:item).where(invoice_id: invoice_id, items: { merchant_id: merchant_id })
  end
end