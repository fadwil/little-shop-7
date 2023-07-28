require "rails_helper"

RSpec.describe "merchants/:merchant_id/invoices/:invoice_id show page" do

  xit "shows invoice ID, invoice status, formatted created_at date, and customer first and last name" do
    merchant = Merchant.first
    invoice = merchant.invoices.first
    formatted_creation_date = invoice.format_created_at
    visit merchant_invoice_path(merchant, invoice)
    require 'pry'; binding.pry
    within "#Facts" do
      expect(page).to have_content("Invoice ID: #{invoice.id}")
      expect(page).to have_content("Invoice status: #{invoice.status}")
      expect(page).to have_content("Created at: #{invoice.format_created_at}")
      expect(page).to have_content("Customer name: #{invoice.customer.first_name} #{invoice.customer.last_name}")
    end 
  end
end
