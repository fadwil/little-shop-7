require 'rails_helper'

RSpec.describe 'Merchant Dashboard', type: :feature do
    test_csv_load
    before(:each) do

        @merchant_1 = Merchant.first

        
    end
    describe 'As a Merchant' do

        describe 'When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)' do
            it 'Shows the name of my merchant' do
                visit merchant_dashboard_index_path(@merchant_1.id)

                within "#merchant_info" do
                    expect(page).to have_content(@merchant_1.name)
                end
            end

            it 'Has a link to my merchant items index and my merchant invoice index' do
                visit merchant_dashboard_index_path(@merchant_1.id)

                within "#dashboard_nav" do
                    expect(page).to have_link("My Items")
                    expect(page).to have_link("My Invoices")
                    click_link "My Items"
                    expect(current_path).to be("/merchants/#{@merchant_1.id}/items")
                end

                visit merchant_dashboard_index_path(@merchant_1.id)

                within "#dashboard_nav" do
                    expect(page).to have_link("My Items")
                    expect(page).to have_link("My Invoices")
                    click_link "My Invoices"
                    expect(current_path).to be("/merchants/#{@merchant_1.id}/invoices")
                end
            end
            
            it 'Shows my top 5 customers who have the largest number of successful transactions' do

                visit merchant_dashboard_index_path(@merchant_1.id)

                within '#merchat_statistics' do
                    expect(@customer_1).to appear_before(@customer_3)
                    expect(@customer_3).to appear_before(@customer_2)
                    expect(@customer_2).to appear_before(@customer_5)
                    expect(@customer_5).to appear_before(@customer_4)
                    expect(@customer_5).to appear_before(@customer_4)
                end
                
            end

            it 'Shows the number of successful transactions next to each customer' do

                visit merchant_dashboard_index_path(@merchant_1.id)

                within '#merchant_statistics' do

                    expect(@customer_1).to appear_before("Successful Transactions: 5")
                    expect(@customer_3).to appear_before("Successful Transactions: 4")
                    expect(@customer_2).to appear_before("Successful Transactions: 3")
                    expect(@customer_5).to appear_before("Successful Transactions: 2")
                    expect(@customer_4).to appear_before("Successful Transactions: 1")

                end
            end

            it 'Shows a section of Items Ready To Ship' do

                visit merchant_dashboard_index_path(@merchant_1.id)

                within "#items_not_shipped" do
                    expect(page).to have_content(@item_2)
                    expect(page).to have_content(@item_3)
                    expect(page).to have_content(@item_4)
                    expect(page).to have_content(@item_6)
                    expect(page).to have_content(@item_9)
                    expect(page).to have_content(@item_10)
                    expect(page).to have_content(@item_12)
                    expect(page).to have_content(@item_15)
                    expect(page).to have_content(@item_17)
                    expect(page).to have_content(@item_18)
                    expect(page).to have_content(@item_19)
                    expect(page).to have_content(@item_20)
                end

                within "#item_#{@item_2.id}" do
                    expect(page).to have_content(@item_2.name)
                    expect(page).to have_link("Invoice")
                    click_link

                    expect(current_path).to be(invoice_show_path)
                end

                within "#item_#{@item_3.id}" do
                    expect(page).to have_content(@item_2.name)
                    expect(page).to have_link("Invoice")
                    click_link

                    expect(current_path).to be(invoice_show_path)
                end
            end
        end
    end
end