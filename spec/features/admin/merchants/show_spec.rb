require "rails_helper"

RSpec.describe "/admin/merchants/:merchant_id", type: :feature do
  describe "Admin Merchant show page" do
    it "I see the name of that merchant" do
      merchant_1 = Merchant.create!(name: "Merchant 1")
      merchant_2 = Merchant.create!(name: "Merchant 2")
      merchant_3 = Merchant.create!(name: "Merchant 3")

      visit "/admin/merchants/#{merchant_1.id}"

      expect(page).to have_content("#{merchant_1.name}")
    end

    it "I see a link to update the merchants information" do
      merchant_1 = Merchant.create!(name: "Merchant 1")
      
      visit "/admin/merchants/#{merchant_1.id}" 

      expect(page).to have_link("Update info")

      click_link("Update info")

      expect(current_path).to eq("/admin/merchants/#{merchant_1.id}/edit")
    end
  end
end