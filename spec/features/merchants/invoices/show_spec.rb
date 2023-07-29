require "rails_helper"

RSpec.describe "merchants/:merchant_id/invoices/:invoice_id show page" do
  test_csv_load
  it "shows invoice ID, invoice status, formatted created_at date, and customer first and last name" do
    merchant = Merchant.first
    merchant_2 = Merchant.last
    invoice = Invoice.create!(customer_id: 3, status: "in progress")
    customer = Customer.find(3)
    visit merchant_invoice_path(merchant, invoice)

    within "#Facts" do
      expect(page).to have_content("Invoice ID: #{invoice.id}")
      expect(page).to have_content("Invoice status: #{invoice.status}")
      expect(page).to have_content("Created at: #{invoice.format_created_at}")
      expect(page).to have_content("Customer name: #{invoice.customer.first_name} #{invoice.customer.last_name}")
    end 
  end

  it "shows all items sold in the invoice by the merchant and not items by other merchants, as well as item attributes" do
    merchant = Merchant.first
    merchant_2 = Merchant.last
    invoice = Invoice.create!(customer_id: 3, status: "in progress")
    customer = Customer.find(3)
    item_1 = merchant.items.create!(name: "Pogo stick", unit_price: 25000)
    item_2 = merchant.items.create!(name: "Hula hoop", unit_price: 15000)
    item_3 = merchant.items.create!(name: "Boomerang", unit_price: 10000)
    item_4 = merchant_2.items.create!(name: "Silly putty", unit_price: 5000)
    invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice.id, quantity: 3, unit_price: item_1.unit_price, status: "shipped")
    invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice.id, quantity: 1, unit_price: item_2.unit_price, status: "packaged")
    invoice_item_3 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice.id, quantity: 4, unit_price: item_3.unit_price, status: "packaged")
    invoice_item_4 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice.id, quantity: 7, unit_price: item_4.unit_price, status: "pending")
    visit merchant_invoice_path(merchant, invoice)

    within "#Items" do
      expect(page).to have_content(item_1.name)
      expect(page).to have_content(item_1.invoice_items[0].quantity)
      expect(page).to have_content(item_1.invoice_items[0].unit_price)
      expect(page).to have_content(item_1.invoice_items[0].status)
      expect(page).to_not have_content(item_4.name)
      expect(page).to_not have_content(item_4.invoice_items[0].quantity)
      expect(page).to_not have_content(item_4.invoice_items[0].status)    
    end 
  end

  it "shows all items sold in the invoice by the merchant and not items by other merchants, as well as item attributes" do
    merchant = Merchant.first
    merchant_2 = Merchant.last
    invoice = Invoice.create!(customer_id: 3, status: "in progress")
    customer = Customer.find(3)
    item_1 = merchant.items.create!(name: "Pogo stick", unit_price: 25000)
    item_2 = merchant.items.create!(name: "Hula hoop", unit_price: 15000)
    item_3 = merchant.items.create!(name: "Boomerang", unit_price: 10000)
    item_4 = merchant_2.items.create!(name: "Silly putty", unit_price: 5000)
    invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice.id, quantity: 3, unit_price: item_1.unit_price, status: "shipped")
    invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice.id, quantity: 1, unit_price: item_2.unit_price, status: "packaged")
    invoice_item_3 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice.id, quantity: 4, unit_price: item_3.unit_price, status: "packaged")
    invoice_item_4 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice.id, quantity: 7, unit_price: item_4.unit_price, status: "pending")
    visit merchant_invoice_path(merchant, invoice)
    
    within "#Total_revenue" do
      expect(page).to have_content(merchant.total_revenue_for_invoice(invoice.id))
      expect(page).to_not have_content(merchant_2.total_revenue_for_invoice(invoice.id))    
    end 
  end

  it "shows all items sold in the invoice by the merchant and not items by other merchants, as well as item attributes" do
    merchant = Merchant.first
    merchant_2 = Merchant.last
    invoice = Invoice.create!(customer_id: 3, status: "in progress")
    customer = Customer.find(3)
    item_1 = merchant.items.create!(name: "Pogo stick", unit_price: 25000)
    item_2 = merchant.items.create!(name: "Hula hoop", unit_price: 15000)
    item_3 = merchant.items.create!(name: "Boomerang", unit_price: 10000)
    item_4 = merchant_2.items.create!(name: "Silly putty", unit_price: 5000)
    invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice.id, quantity: 3, unit_price: item_1.unit_price, status: "shipped")
    invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice.id, quantity: 1, unit_price: item_2.unit_price, status: "packaged")
    invoice_item_3 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice.id, quantity: 4, unit_price: item_3.unit_price, status: "packaged")
    invoice_item_4 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice.id, quantity: 7, unit_price: item_4.unit_price, status: "pending")
    visit merchant_invoice_path(merchant, invoice)
    
    within "#Boomerang" do
      expect(page).to have_content("packaged")
      expect(page).to_not have_content("shipped")

      click_button("Shipped")

      expect(page).to have_content("shipped")
      expect(page).to_not have_content("packaged")
    end 

    expect(invoice_item_3.status).to eq("shipped")
  end
end
