require 'rails_helper'

RSpec.describe 'Admin Dashboard', type: :feature do
  before(:each) do
    InvoiceItem.destroy_all
    Transaction.destroy_all
    Invoice.destroy_all
    Item.destroy_all
    Merchant.destroy_all
    Customer.destroy_all
    @merchant_1 = Merchant.create!(name: "Walmart")
      @item_1 = Item.create!(name: "Bicycle", description: "It has 2 wheels and pedals.", unit_price: 500, merchant_id: @merchant_1.id)
      @customer_1 = Customer.create!(first_name: "Dan", last_name: "Smith")
      @customer_2 = Customer.create!(first_name: "Will", last_name: "Smoth")
      @customer_3 = Customer.create!(first_name: "Bill", last_name: "Smyth")
      @customer_4 = Customer.create!(first_name: "Dave", last_name: "Smeth")
      @customer_5 = Customer.create!(first_name: "Sally", last_name: "Smith")
      @customer_6 = Customer.create!(first_name: "Dan", last_name: "Smath")
      @customer_7 = Customer.create!(first_name: "Jane", last_name: "Smith")
      @invoice_1 = Invoice.create!(status: "completed", customer_id: @customer_1.id)
      @invoice_2 = Invoice.create!(status: "completed", customer_id: @customer_1.id)
      @invoice_3 = Invoice.create!(status: "completed", customer_id: @customer_1.id)
      @invoice_4 = Invoice.create!(status: "completed", customer_id: @customer_2.id)
      @invoice_5 = Invoice.create!(status: "completed", customer_id: @customer_2.id)
      @invoice_6 = Invoice.create!(status: "completed", customer_id: @customer_2.id)
      @invoice_7 = Invoice.create!(status: "completed", customer_id: @customer_3.id)
      @invoice_8 = Invoice.create!(status: "completed", customer_id: @customer_3.id)
      @invoice_9 = Invoice.create!(status: "completed", customer_id: @customer_4.id)
      @invoice_10 = Invoice.create!(status: "completed", customer_id: @customer_4.id)
      @invoice_11 = Invoice.create!(status: "completed", customer_id: @customer_5.id)
      @invoice_12 = Invoice.create!(status: "in progress", customer_id: @customer_6.id)
      @invoice_13 = Invoice.create!(status: "in progress", customer_id: @customer_7.id)
      @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 5, unit_price: 25000, status: "shipped")
      @invoice_item_2 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_2.id, quantity: 5, unit_price: 25000, status: "shipped")
      @invoice_item_3 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_3.id, quantity: 5, unit_price: 25000, status: "shipped")
      @invoice_item_4 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_4.id, quantity: 5, unit_price: 25000, status: "shipped")
      @invoice_item_5 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_5.id, quantity: 5, unit_price: 25000, status: "shipped")
      @invoice_item_6 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_6.id, quantity: 5, unit_price: 25000, status: "shipped")
      @invoice_item_7 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_7.id, quantity: 5, unit_price: 25000, status: "shipped")
      @invoice_item_8 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_8.id, quantity: 5, unit_price: 25000, status: "shipped")
      @invoice_item_9 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_9.id, quantity: 5, unit_price: 25000, status: "shipped")
      @invoice_item_10 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_10.id, quantity: 5, unit_price: 25000, status: "shipped")
      @invoice_item_11 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_11.id, quantity: 5, unit_price: 25000, status: "shipped")
      @invoice_item_12 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_12.id, quantity: 5, unit_price: 25000, status: "pending")
      @invoice_item_13 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_13.id, quantity: 5, unit_price: 25000, status: "pending")
      @transaction_1 = Transaction.create!(invoice_id: @invoice_1.id, credit_card_number: "7990276485696308", credit_card_expiration_date: "01/01", result: "success")
      @transaction_2 = Transaction.create!(invoice_id: @invoice_2.id, credit_card_number: "7990276485696308", credit_card_expiration_date: "01/01", result: "success")
      @transaction_3 = Transaction.create!(invoice_id: @invoice_3.id, credit_card_number: "7990276485696308", credit_card_expiration_date: "01/01", result: "success")
      @transaction_4 = Transaction.create!(invoice_id: @invoice_4.id, credit_card_number: "3351425910817706", credit_card_expiration_date: "02/01", result: "success")
      @transaction_5 = Transaction.create!(invoice_id: @invoice_5.id, credit_card_number: "3351425910817706", credit_card_expiration_date: "02/01", result: "success")
      @transaction_6 = Transaction.create!(invoice_id: @invoice_6.id, credit_card_number: "3351425910817706", credit_card_expiration_date: "02/01", result: "success")
      @transaction_7 = Transaction.create!(invoice_id: @invoice_7.id, credit_card_number: "4161047845230560", credit_card_expiration_date: "03/01", result: "success")
      @transaction_8 = Transaction.create!(invoice_id: @invoice_8.id, credit_card_number: "4161047845230560", credit_card_expiration_date: "03/01", result: "success")
      @transaction_9 = Transaction.create!(invoice_id: @invoice_9.id, credit_card_number: "9075387155233498", credit_card_expiration_date: "04/01", result: "success")
      @transaction_10 = Transaction.create!(invoice_id: @invoice_10.id, credit_card_number: "9075387155233498", credit_card_expiration_date: "04/01", result: "success")
      @transaction_11 = Transaction.create!(invoice_id: @invoice_11.id, credit_card_number: "8154916084080022", credit_card_expiration_date: "05/01", result: "success")
      @transaction_12 = Transaction.create!(invoice_id: @invoice_12.id, credit_card_number: "1191993766451254", credit_card_expiration_date: "06/01", result: "failed")
      @transaction_13 = Transaction.create!(invoice_id: @invoice_13.id, credit_card_number: "2079801981307339", credit_card_expiration_date: "07/01", result: "failed")
    visit "/admin"
  end

  it 'exists with header' do
    expect(page).to have_content('Admin Dashboard')
  end

  it 'has links to the admin merchants and invoices index' do
    expect(page).to have_link("Merchants", href: "/admin/merchants")
    expect(page).to have_link("Invoices", href: "/admin/invoices")
  end

  it 'displays the names of the top 5 customers with purchase amounts' do
    expect(page).to have_content("Top Customers")
    expect(page).to have_content("Dan Smith - 3 Purchases")
    expect(page).to have_content("Will Smoth - 3 Purchases")
    expect(page).to have_content("Bill Smyth - 2 Purchases")
    expect(page).to have_content("Dave Smeth - 2 Purchases")
    expect(page).to have_content("Sally Smith - 1 Purchases")
    expect(page).to_not have_content("Dan Smath")
    expect(page).to_not have_content("Jane Smith")
  end

  it 'has an incomplete invoices section' do
    expect(page).to_not have_content(@invoice_1.id)
    expect(page).to have_link("#{@invoice_12.id}", href: "/admin/invoices/#{@invoice_12.id}")
    expect(page).to have_link("#{@invoice_13.id}", href: "/admin/invoices/#{@invoice_13.id}")
    click_link(@invoice_12.id)
    expect(current_path).to eq("/admin/invoices/#{@invoice_12.id}")
  end

  it "lists each incomplete invoice from oldest to newest" do
      expect(page).to have_link("#{@invoice_12.id}")
      expect(page).to have_link("#{@invoice_13.id}")
      expect("#{@invoice_12.id}").to appear_before("#{@invoice_13.id}")
      expect(page).to_not have_link("#{@invoice_1.id}")
  end
end