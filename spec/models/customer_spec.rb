require "rails_helper"

RSpec.describe Customer, type: :model do
  describe "relationships" do
    it { should have_many :invoices }
  end

  describe "class methods" do
    before(:each) do
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
      @invoice_12 = Invoice.create!(status: "in_progress", customer_id: @customer_6.id)
      @invoice_13 = Invoice.create!(status: "in_progress", customer_id: @customer_7.id)
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
    end
    it ".top_customers_with_transactions" do
      expected = [@customer_1, @customer_2, @customer_3, @customer_4, @customer_5]
      expect(Customer.top_customers_with_transactions).to eq(expected)
      expect(Customer.top_customers_with_transactions).to_not eq([@customer_6, @customer_7])
    end
  end
end