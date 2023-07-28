require 'rails_helper'

RSpec.describe 'Merchant Dashboard', type: :feature do
    before(:each) do

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
            
            xit 'Shows my top 5 customers who have the largest number of successful transactions, and next to each I see the number of successful transactions they have made' do

                visit merchant_dashboard_index_path(@merchant_1.id)
            end
        end
    end
end