require "rails_helper"

RSpec.describe "/admin/invoices/:invoice_id" do
  describe "When I visit the admin invoices show page" do
    before do
      @merchant_1 = Merchant.create(name: "Merchant 1")
      @item_1 = Item.create!(name: "Bicycle", description: "It has 2 wheels and pedals.", unit_price: 500, merchant_id: @merchant_1.id)
      @item_2 = Item.create!(name: "Boot", description: "Goes on foot.", unit_price: 500, merchant_id: @merchant_1.id)
      @customer_1 = Customer.create!(first_name: "Dan", last_name: "Smith")
      @customer_2 = Customer.create!(first_name: "Will", last_name: "Smoth")
      @invoice_1 = Invoice.create!(status: "completed", customer_id: @customer_1.id)
      @invoice_2 = Invoice.create!(status: "completed", customer_id: @customer_2.id)
      @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 5, unit_price: 25000, status: "shipped")
      @invoice_item_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 5, unit_price: 25000, status: "shipped")
      @invoice_item_3 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 5, unit_price: 25000, status: "shipped")
    end

    it "has all items on an invoice with the invoice id, status, created at, and customer name" do
      visit "admin/invoices/#{@invoice_1.id}"
      
      expect(page).to have_content("Invoice ##{@invoice_1.id}")
      expect(page).to have_content("Invoice Status:")
      expect(page).to have_select("invoice_status", selected: @invoice_1.status.titleize)
      expect(page).to have_content("Created On: #{@invoice_1.format_created_at}")
      expect(page).to have_content("Customer Name: Dan Smith")
      
      visit "admin/invoices/#{@invoice_2.id}"
      
      expect(page).to have_content("Invoice ##{@invoice_2.id}")
      expect(page).to have_content("Invoice Status:")
      expect(page).to have_select("invoice_status", selected: @invoice_2.status.titleize)
      expect(page).to have_content("Created On: #{@invoice_2.format_created_at}")
      expect(page).to have_content("Customer Name: Will Smoth")
    end
  end
end