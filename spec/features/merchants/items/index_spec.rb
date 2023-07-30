require "rails_helper"

RSpec.describe "merchants/:merchant_id/items index" do
  test_csv_load
  it "displays all items associated with a merchant" do
    merchant = Merchant.first
    merchant_2 = Merchant.last
    visit merchant_items_path(merchant)

    expect(page).to have_content("#{merchant.name}'s Items")
    expect(page).to have_content(merchant.items.sample.name)
    expect(page).to_not have_content(merchant_2.items.sample.name)
  end

  it "displays item status and has a form to update that item status" do
    merchant = Merchant.first
    visit merchant_items_path(merchant)
    item = merchant.items.sample

    within "div#item_#{item.id}" do
      expect(page).to_not have_content("enabled")
      expect(page).to have_content("disabled")

      click_button "enable"

      expect(page).to have_content("enabled")
      expect(page).to_not have_content("disabled")
    end
  end
end