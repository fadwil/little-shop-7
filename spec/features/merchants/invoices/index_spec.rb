require "rails_helper"

RSpec.describe "merchants/:merchant_id/invoices index" do
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

  it "displays all invoices that show at least one merchant item and each ID links to invoice show page" do
    merchant = Merchant.all.sample
    visit merchant_invoices_path(merchant)

    expect(page).to have_content("#{merchant.name}'s Invoices")
    expect(page).to have_content(merchant.invoices.sample.status)
    expect(page).to have_content(merchant.invoices.sample.id)

    invoice = merchant.invoices.sample
    click_link(invoice.id)
    expect(current_path).to eq(merchant_invoice_path(merchant, invoice))
  end
end
