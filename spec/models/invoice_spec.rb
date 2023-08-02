require "rails_helper"

RSpec.describe Invoice, type: :model do
  test_csv_load
  before(:each) do
    @invoice_1 = Invoice.first
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  end

  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe "instance methods" do


    before(:each) do
      Customer.destroy_all
      InvoiceItem.destroy_all
      Invoice.destroy_all
      Item.destroy_all
      Merchant.destroy_all
      Transaction.destroy_all
  
      10.times do
        Customer.create!(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name
        )
      end
  
      5.times do
        Merchant.create!(
          name: Faker::Company.name
        )
      end
  
      Merchant.all.each do |merchant|
        10.times do
          merchant.items.create!(
            name: Faker::Commerce.product_name,
            description: Faker::Lorem.sentence,
            unit_price: Faker::Number.between(from: 100, to: 10000)
          )
        end
      end
  
      Customer.all.each do |customer|
        5.times do
          invoice = customer.invoices.create!(
            status: ['cancelled', 'completed', 'in_progress'].sample
          )
          @invoice_1 = customer.invoices.create!(status: :in_progress, created_at: "2012-03-25 09:54:09 UTC")
  
          Item.all.sample(5).each do |item|
            invoice.invoice_items.create!(
              quantity: Faker::Number.between(from: 1, to: 5),
              unit_price: item.unit_price,
              status: ['shipped', 'pending'].sample,
              item: item
            )
          end
      
          invoice.transactions.create!(
            credit_card_number: Faker::Business.credit_card_number,
            credit_card_expiration_date: Faker::Business.credit_card_expiry_date,
            result: ['success', 'failed'].sample
          )
        end
      end
   
    it "can format the created_at date of an invoice" do
      invoice = Invoice.create!(customer_id: 3, status: "completed", created_at: "2012-03-25 09:54:09 UTC")
      expect(invoice.format_created_at).to eq("Sunday, March 25, 2012")
    end

    it "can determine if any transactions were successful" do
      invoice = Invoice.create!(customer_id: 3, status: "completed", created_at: "2012-03-25 09:54:09 UTC")
      expect(invoice.transactions_successful?).to eq false
      transaction = invoice.transactions.create!(result: "success")
      expect(invoice.transactions_successful?).to eq true
    end

    it "can return all incomplete invoices" do
      expect(Invoice.unshipped_invoices.none? { |invoice| invoice.status == "shipped" }).to be true
    end
  end
end