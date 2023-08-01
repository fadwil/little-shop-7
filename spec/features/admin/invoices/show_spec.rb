require "rails_helper"

RSpec.describe "/admin/invoices/:invoice_id" do
  describe "When I visit the admin invoices show page" do
    before do
      @merchant_1 = Merchant.create(name: "Merchant 1")
      @item_1 = Item.create!(name: "Bicycle", description: "It has 2 wheels and pedals.", unit_price: 500, merchant_id: @merchant_1.id)
      @item_2 = Item.create!(name: "Boot", description: "Goes on foot.", unit_price: 100, merchant_id: @merchant_1.id)
      @customer_1 = Customer.create!(first_name: "Dan", last_name: "Smith")
      @customer_2 = Customer.create!(first_name: "Will", last_name: "Smoth")
      @invoice_1 = Invoice.create!(status: "completed", customer_id: @customer_1.id)
      @invoice_2 = Invoice.create!(status: "completed", customer_id: @customer_2.id)
      @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 5, unit_price: 25000, status: "shipped")
      @invoice_item_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 5, unit_price: 2500, status: "shipped")
      @invoice_item_3 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 5, unit_price: 2500, status: "shipped")
    end

    it "has shows all info for the invoice with the invoice id, status, created at, and customer name" do
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

    it "shows all items on the invoice including name, quantity, price, and invoice item status" do
      visit "admin/invoices/#{@invoice_1.id}"
      
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@invoice_item_1.quantity)
      expect(page).to have_content("$25,000.00")
      expect(page).to have_content(@invoice_item_1.status)

      expect(page).to have_content(@item_2.name)
      expect(page).to have_content(@invoice_item_1.quantity)
      expect(page).to have_content("$2,500")
      expect(page).to have_content(@invoice_item_1.status)
      
      visit "admin/invoices/#{@invoice_2.id}"
      
      expect(page).to have_content(@item_2.name)
      expect(page).to have_content(@invoice_item_2.quantity)
      expect(page).to have_content("$2,500")
      expect(page).to have_content(@invoice_item_2.status)
    end

    it "displays total revenue for that invoice" do
      visit "admin/invoices/#{@invoice_1.id}"
      
      expect(page).to have_content("$137,500.00")
      expect(page).to_not have_content("$12,500.00")
    end
  end
end