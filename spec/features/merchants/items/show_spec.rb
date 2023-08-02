require 'rails_helper'

RSpec.describe 'Item Show Page', type: :feature do
    test_csv_load
    before(:each) do
        @merchant_1 = Merchant.first
        @item_1 = @merchant_1.items.first
    end

    describe 'As a Merchant' do
        describe 'when I click the name of an item on the item index page (merchants/:merchant_id/items)' do
            describe 'Takes me to that merchants items show page' do
                
                it 'shows an image' do

                    visit merchant_item_path(@merchant_1.id, @item_1)

                    expect(page).to have_css('img')
                end 

                it 'Shows all the items attributes' do

                    visit merchant_item_path(@merchant_1.id, @item_1)
                    
                    within "#item_attributes" do
                        expect(page).to have_content(@item_1.name)
                        expect(page).to have_content(@item_1.description)
                        expect(page).to have_content(@item_1.unit_price)
                    end
                end
                it 'Has a link to update the item informantion' do

                    visit merchant_item_path(@merchant_1.id, @item_1)

                    within "#item_attributes" do
                        expect(page).to have_content(@item_1.name)
                        expect(page).to have_content(@item_1.description)
                        expect(page).to have_content(@item_1.unit_price)
                    end

                    expect(page).to have_link("Update Item Info")

                    click_link

                    within "#item_update" do
                        fill_in :name, with: "Changed Name"
                        fill_in :description, with: "Updated Description"
                        fill_in :unit_price, with: "7500"
                        click_button "Update Item"
                    end

                    visit merchant_item_path(@merchant_1.id, @item_1)
                    
                    within "#item_attributes" do
                        expect(page).to have_content("Changed Name")
                        expect(page).to have_content("Updated Description")
                        expect(page).to have_content("7500")
                    end

                end
            end
        end
    end
end