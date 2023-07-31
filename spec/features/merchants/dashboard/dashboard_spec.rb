require 'rails_helper'

RSpec.describe 'Merchant Dashboard', type: :feature do
    test_csv_load
    before(:each) do
        @merchant_1 = Merchant.first
        @item_1 = Item.find(1)
        @item_2 = Item.find(2)
        @item_3 = Item.find(3)
        @item_4 = Item.find(4)
        @invoice_1 = @merchant_1.items_status.find(1)
        @invoice_2 = @merchant_1.items_status.find(2)
        @invoice_3 = @merchant_1.items_status.find(3)
        @invoice_4 = @merchant_1.items_status.find(4)
        

    end
    describe 'As a Merchant' do
        describe 'When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)' do
            xit 'Shows the name of my merchant' do
                visit merchant_dashboard_index_path(@merchant_1.id)

                within "#merchant_info" do
                    expect(page).to have_content(@merchant_1.name)
                end
            end

            xit 'Has a link to my merchant items index and my merchant invoice index' do
                visit merchant_dashboard_index_path(@merchant_1.id)

                within "#dashboard_nav" do
                    expect(page).to have_link("My Items")
                    expect(page).to have_link("My Invoices")
                    click_link "My Items"
                    expect(current_path).to eq("/merchants/#{@merchant_1.id}/items")
                end

                visit merchant_dashboard_index_path(@merchant_1.id)

                within "#dashboard_nav" do
                    expect(page).to have_link("My Items")
                    expect(page).to have_link("My Invoices")
                    click_link "My Invoices"
                    expect(current_path).to eq("/merchants/#{@merchant_1.id}/invoices")
                end
            end
            
            xit 'Shows my top 5 customers who have the largest number of successful transactions, and next to each I see the number of successful transactions they have made' do

                visit merchant_dashboard_index_path(@merchant_1.id)
            end

            it 'Shows a list of items that havent been shipped, and the invoice id that is a link to the invoice' do

                visit merchant_dashboard_index_path(@merchant_1.id)

                within "#dashboard_items_status" do
                    within "#item_#{@item_1.id}" do
                        expect(page).to have_content(@item_1.name)
                        expect(page).to have_link("#{@invoice_1.invoice_id}")
                    end  
                    within "#item_#{@item_2.id}" do
                        expect(page).to have_content(@item_2.name)
                        expect(page).to have_link("#{@invoice_2.invoice_id}")
                    end  
                    within "#item_#{@item_3.id}" do
                        expect(page).to have_content(@item_3.name)
                        expect(page).to have_link("#{@invoice_3.invoice_id}")
                    end  
                    within "#item_#{@item_4.id}" do
                        expect(page).to have_content(@item_4.name)
                        expect(page).to have_link(@invoice_4.invoice_id)
                    end
                end
            end
        end
    end
end