require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :items }
    it { should have_many(:invoices).through(:items) }
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
    end

    it "does not return repeat invoices if multiple items from the merchant were sold in the same invoice" do
      merchant = Merchant.all.sample
      expect(merchant.distinct_invoices.count).to_not eq(merchant.invoices.count)
    end
  end
end