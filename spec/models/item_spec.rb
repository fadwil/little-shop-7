require "rails_helper"

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items)}
  end

  describe "instance methods" do
    it "can calculate total revenue from invoice_items where invoice has at least one successful transaction" do
      merchant = Merchant.first
      merchant_2 = Merchant.last
      invoice = Invoice.create!(customer_id: 3, status: "completed")
      transaction = invoice.transactions.create!(result: "success")
      transaction_2 = invoice.transactions.create!(result: "failed")

      invoice_2 = Invoice.create!(customer_id: 5, status: "cancelled")
      transaction_3 = invoice_2.transactions.create!(result: "failed")
      transaction_4 = invoice_2.transactions.create!(result: "failed")

      item_1 = merchant.items.create!(name: "Pogo stick", unit_price: 25000)
      item_2 = merchant.items.create!(name: "Hula hoop", unit_price: 15000)
      invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice.id, quantity: 3, unit_price: item_1.unit_price, status: "shipped")
      invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_2.id, quantity: 2, unit_price: item_2.unit_price, status: "packaged")
      
      expect(item_1.total_revenue).to eq(75000)
      expect(item_2.total_revenue).to eq(0)
    end
  end
end