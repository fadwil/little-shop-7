require "rails_helper"

RSpec.describe "merchants/:merchant_id/invoices index" do
  test_csv_load

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
