require "rails_helper"

RSpec.describe "/admin/merchants/:merchant_id/edit", type: :feature do
  describe "admin merchants edit page" do
    it "I see a form with the existing attributes filled in" do
      merchant_1 = Merchant.create!(name: "Merchant 1")
      visit "/admin/merchants/#{merchant_1.id}/edit"
      expect(page).to have_field("Name", with: "Merchant 1")
    end

    it "when I update the information and click submit I am taken back to show and see the updated info" do
      merchant_1 = Merchant.create!(name: "merchant 1")
      visit "/admin/merchants/#{merchant_1.id}/edit"
      
      fill_in("Name", with: "Merchant #1")
      click_button("Submit")
      expect(current_path).to eq("/admin/merchants/#{merchant_1.id}")
      expect(page).to have_content("Merchant #1")
      expect(:alert).to be_present
    end
  end
end
