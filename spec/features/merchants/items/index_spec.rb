require "rails_helper"

RSpec.describe "merchants/:merchant_id/items index" do
    test_csv_load
    before(:each) do
        ActiveRecord::Base.connection.reset_pk_sequence!('merchants')
        ActiveRecord::Base.connection.reset_pk_sequence!('items')
        ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
        ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
        ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
        @merchant_1 = Merchant.first
        @merchant_2 = Merchant.find(2)
        @item_1 = @merchant_1.items.first
        @item_2 = @merchant_1.items.create!(name: "Hula hoop")
        @item_3 = @merchant_2.items.create!(name: "Boomerang")
        @item_4 = @merchant_2.items.create!(name: "Barbie")
    end

    it "displays all items associated with a merchant" do
        @merchant_1 = Merchant.first
        @merchant_2 = Merchant.last
        visit merchant_items_path(@merchant_1)

        expect(page).to have_content("#{@merchant_1.name}'s Items")
        expect(page).to have_content(@merchant_1.items.sample.name)
    end

    it "displays item status and has a form to update that item status" do
        visit merchant_items_path(@merchant_1)
        item = @merchant_1.items.sample
        within "div#item_#{item.id}" do
            expect(page).to_not have_content("enabled")
            expect(page).to have_content("disabled")
            
            click_button "Enable"
            expect(current_path).to eq(merchant_items_path(@merchant_1))
            expect(page).to have_content("enabled")
            expect(page).to_not have_content("disabled")
        end
    end

    it "groups items by item status" do
        merchant = Merchant.first
        item_1 = merchant.items[0]
        item_2 = merchant.items[1]
        item_3 = merchant.items[2]
        item_4 = merchant.items[3]
        item_1.update(status:"enabled")
        item_2.update(status:"enabled")
        visit merchant_items_path(@merchant_1)

        within "#Enabled" do
            expect(page).to have_content(item_1.name)
            expect(page).to have_content(item_2.name)
            expect(page).to_not have_content(item_3.name)
            expect(page).to_not have_content(item_4.name)
        end

        within "#Disabled" do
            expect(page).to have_content(item_3.name)
            expect(page).to have_content(item_4.name)
            expect(page).to_not have_content(item_1.name)
            expect(page).to_not have_content(item_2.name)
        end
    end

    it "shows top 5 items ranked in order of total revenue generated, the item is a link to its show page, and the total revenue is displayed" do
        merchant = Merchant.create!(name: "Toyz R Uz")
        merchant_2 = Merchant.create!(name: "Mercantile")
        invoice = Invoice.create!(customer_id: 3, status: "completed")
        transaction = invoice.transactions.create!(result: "success")
        invoice_2 = Invoice.create!(customer_id: 1, status: "completed")
        transaction_2 = invoice_2.transactions.create!(result: "failed")

        item_1 = merchant.items.create!(name: "Pogo stick")
        item_2 = merchant.items.create!(name: "Hula hoop")
        item_3 = merchant.items.create!(name: "Boomerang")
        item_4 = merchant.items.create!(name: "Barbie")
        item_5 = merchant.items.create!(name: "Tonka truck")
        item_6 = merchant.items.create!(name: "Leggos")
        item_7 = merchant.items.create!(name: "Kinex")
        item_8 = merchant_2.items.create!(name: "Silly putty")

        invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice.id, quantity: 3, unit_price: 25000, status: "shipped")
        invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice.id, quantity: 3, unit_price: 30000, status: "packaged")
        invoice_item_3 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice.id, quantity: 3, unit_price: 45000, status: "packaged")
        invoice_item_4 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice.id, quantity: 3, unit_price: 60000, status: "pending")
        invoice_item_5 = InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice.id, quantity: 3, unit_price: 50000, status: "pending")
        invoice_item_6 = InvoiceItem.create!(item_id: item_6.id, invoice_id: invoice.id, quantity: 3, unit_price: 75000, status: "pending")
        invoice_item_7 = InvoiceItem.create!(item_id: item_7.id, invoice_id: invoice_2.id, quantity: 3, unit_price: 95000, status: "pending")
        invoice_item_8 = InvoiceItem.create!(item_id: item_8.id, invoice_id: invoice.id, quantity: 3, unit_price: 100000, status: "pending")
        expect(merchant.top_items).to eq([item_6, item_4, item_5, item_3, item_2])

        visit merchant_items_path(merchant)

        within "#Top_items" do
            expect(item_6.name).to appear_before(item_4.name)
            expect(item_4.name).to appear_before(item_5.name)
            expect(item_5.name).to appear_before(item_3.name)
            expect(item_3.name).to appear_before(item_2.name)
            expect(page).to_not have_content(item_8.name)
            expect(page).to_not have_content(item_7.name)

            expect(page).to have_content("Total revenue generated for #{item_6.name}: 225000")
            click_link(item_6.name)
            expect(current_path).to eq(merchant_item_path(merchant, item_6))
            visit merchant_items_path(merchant)

            expect(page).to have_content("Total revenue generated for #{item_5.name}: 150000")
            click_link(item_5.name)
            expect(current_path).to eq(merchant_item_path(merchant, item_5))
        end
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

    it "displays the top selling date for each of the merchants top 5 items" do
      merchant = Merchant.create!(name: "Toyz R Uz")
      invoice = Invoice.create!(customer_id: 3, status: "completed", created_at: "2020-03-06")
      invoice_2 = Invoice.create!(customer_id: 5, status: "completed", created_at: "2021-04-07")
      invoice_3 = Invoice.create!(customer_id: 4, status: "completed", created_at: "2022-05-08")
      transaction = invoice.transactions.create!(result: "success")
      transaction_2 = invoice_2.transactions.create!(result: "success")
      transaction_3 = invoice_3.transactions.create!(result: "success")

      item_1 = merchant.items.create!(name: "Pogo stick")
      item_2 = merchant.items.create!(name: "Hula hoop")
      item_3 = merchant.items.create!(name: "Boomerang")
      item_4 = merchant.items.create!(name: "Barbie")
      item_5 = merchant.items.create!(name: "Tonka truck")
      item_6 = merchant.items.create!(name: "Leggos")

      invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice.id, quantity: 3, unit_price: 25000, status: "shipped")
      invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice.id, quantity: 3, unit_price: 30000, status: "packaged")
      invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice.id, quantity: 3, unit_price: 30000, status: "packaged")
      invoice_item_3 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice.id, quantity: 3, unit_price: 45000, status: "packaged")
      invoice_item_4 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice.id, quantity: 3, unit_price: 60000, status: "pending")
      invoice_item_5 = InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice.id, quantity: 3, unit_price: 50000, status: "pending")
      invoice_item_6 = InvoiceItem.create!(item_id: item_6.id, invoice_id: invoice_2.id, quantity: 3, unit_price: 75000, status: "pending")
      invoice_item_9 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_3.id, quantity: 9, unit_price: 60000, status: "pending")
      visit merchant_items_path(merchant)

      within "#Top_items" do
          expect(page).to have_content("Top selling date for #{item_6.name} was #{item_6.top_selling_date.format_created_at}")
          expect(page).to have_content("Top selling date for #{item_5.name} was #{item_5.top_selling_date.format_created_at}")
          expect(page).to have_content("Top selling date for #{item_4.name} was #{item_4.top_selling_date.format_created_at}")
          expect(page).to have_content("Top selling date for #{item_3.name} was #{item_3.top_selling_date.format_created_at}")
          expect(page).to have_content("Top selling date for #{item_2.name} was #{item_2.top_selling_date.format_created_at}")
          expect(page).to_not have_content("Top selling date for #{item_1.name} was #{item_1.top_selling_date.format_created_at}")
      end
    end
end

