require "rails_helper"

RSpec.describe Merchant, type: :model do
  test_csv_load
  before(:each) do
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  end

  describe "relationships" do
    it { should have_many :items }
    it { should have_many(:invoices).through(:items) }
  end

  describe "instance methods" do
    it "does not return repeat invoices if multiple items from the merchant were sold in the same invoice" do
      merchant = Merchant.first
      expect(merchant.distinct_invoices.count).to_not eq(merchant.invoices.count)
    end

    it "returns only the items associated with the specific merchant for a specific invoice" do
      merchant = Merchant.first
      merchant_2 = Merchant.last
      invoice = Invoice.create!(customer_id: 3, status: "completed")
      item_1 = merchant.items.create!(name: "Pogo stick", unit_price: 25000)
      item_2 = merchant.items.create!(name: "Hula hoop", unit_price: 15000)
      item_3 = merchant.items.create!(name: "Boomerang", unit_price: 10000)
      item_4 = merchant_2.items.create!(name: "Silly putty", unit_price: 5000)
      invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice.id, quantity: 3, unit_price: item_1.unit_price, status: "shipped")
      invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice.id, quantity: 1, unit_price: item_2.unit_price, status: "packaged")
      invoice_item_3 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice.id, quantity: 4, unit_price: item_3.unit_price, status: "packaged")
      invoice_item_4 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice.id, quantity: 7, unit_price: item_4.unit_price, status: "pending")
      expect(merchant.items_sold_in_invoice(invoice)).to eq([item_1, item_2, item_3])
    end

    it "returns the total revenue of the merchants items for a given invoice" do
      merchant = Merchant.first
      merchant_2 = Merchant.last
      invoice = Invoice.create!(customer_id: 3, status: "completed")
      item_1 = merchant.items.create!(name: "Pogo stick", unit_price: 25000)
      item_2 = merchant.items.create!(name: "Hula hoop", unit_price: 15000)
      item_3 = merchant.items.create!(name: "Boomerang", unit_price: 10000)
      item_4 = merchant_2.items.create!(name: "Silly putty", unit_price: 5000)
      invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice.id, quantity: 3, unit_price: item_1.unit_price, status: "shipped")
      invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice.id, quantity: 1, unit_price: item_2.unit_price, status: "packaged")
      invoice_item_3 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice.id, quantity: 4, unit_price: item_3.unit_price, status: "packaged")
      invoice_item_4 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice.id, quantity: 7, unit_price: item_4.unit_price, status: "pending")
      expect(merchant.total_revenue_for_invoice(invoice)).to eq(130000)
    end
  end
end