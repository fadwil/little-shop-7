require "rails_helper"

RSpec.describe "merchants/:merchant_id/invoices/:invoice_id show page" do
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
          status: ['pending', 'paid', 'cancelled'].sample
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

  it "shows invoice ID, invoice status, formatted created_at date, and customer first and last name" do
    merchant = Merchant.all.sample
    invoice = merchant.invoices.sample
    merchant_invoice_path(merchant, invoice)

    formatted_creation_date = invoice.format_created_at
    expect(page).to have_content("Invoice ID: #{invoice.id}")
    expect(page).to have_content("Invoice status: #{invoice.status}")
    expect(page).to have_content("Created at: #{invoice.formatted_creation_date}")
    expect(page).to have_content("Customer name: #{invoice.customer.first_name} #{invoice.customer.last_name}")
  end
end
