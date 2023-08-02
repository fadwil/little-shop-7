require "rails_helper"

RSpec.describe Item, type: :model do

  before(:each) do
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  end
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

    it "can identify invoice date with highest quantity of items sold" do
      merchant = Merchant.first
      merchant_2 = Merchant.last
      invoice = Invoice.create!(customer_id: 3, status: "completed", created_at: "2020-03-06")
      invoice_2 = Invoice.create!(customer_id: 5, status: "completed", created_at: "2021-04-07")
      invoice_3 = Invoice.create!(customer_id: 4, status: "completed", created_at: "2022-05-08")

      item_1 = merchant.items.create!(name: "Pogo stick")
      item_2 = merchant.items.create!(name: "Hula hoop")
      item_3 = merchant.items.create!(name: "Boomerang")
      item_4 = merchant.items.create!(name: "Barbie")

      invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_10 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_2.id, quantity: 3, unit_price: 25000, status: "shipped")
      invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_2.id, quantity: 3, unit_price: 30000, status: "packaged")
      invoice_item_3 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice.id, quantity: 3, unit_price: 45000, status: "packaged")
      invoice_item_4 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice.id, quantity: 3, unit_price: 60000, status: "pending")
      invoice_item_9 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_3.id, quantity: 9, unit_price: 60000, status: "pending")

      expect(item_1.top_selling_date.format_created_at).to eq("Friday, March 06, 2020")
      expect(item_2.top_selling_date.format_created_at).to eq("Wednesday, April 07, 2021")
      expect(item_4.top_selling_date.format_created_at).to eq("Sunday, May 08, 2022")
    end
  end
end