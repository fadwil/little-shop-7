require 'rails_helper'

RSpec.describe 'Item Index Page', type: :feature do
    test_csv_load
    before(:each) do
        @merchant_1 = Merchant.first
        @item_1 = @merchant_1.items.first
    end
    describe 'As a Merchant' do
        describe 'when I visit the items index page (merchants/:merchant_id/items)' do

            it 'Shows a list of all my merchants items' do

            end

            it 'Has each items name as a link to that items show page' do

                visit merchant_items_path(@merchant_1)

                expect(page).to have_link(@item_1.name)

                click_link(@item_1.name)

                expect(current_path).to eq(merchant_item_path(@item_1, @merchant_1))

            end

            it 'Has a link to create a new item' do

                visit merchant_items_path(@merchant_1)

                expect(page).to have_link("Create New Item")

                click_link("Create New Item")

                within "#new_item" do
                    fill_in :name, with: "A new item"
                    fill_in :description, with: "A new description"
                    fill_in :unit_price, with: "8526"

                    click_button "Create Item"
                end

                expect(current_path).to eq(merchant_items_path(@merchant_1))

                expect(page).to have_link("A new item")
                
                click_link("A new item")

                expect(page).to have_content("A new item")
                expect(page).to have_content("A new description")
                expect(page).to have_content("8526")

            end
        end
    end
end 