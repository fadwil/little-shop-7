require "rails_helper"

RSpec.describe "/admin /merchants", type: :feature do
  describe "admin merchants index page" do
    it "has the name of each merchant in the system" do
      merchant_1 = Merchant.create!(name: "Merchant 1")
      merchant_2 = Merchant.create!(name: "Merchant 2")
      merchant_3 = Merchant.create!(name: "Merchant 3")

      visit "/admin/merchants"
      
      expect(page).to have_content("Merchant 1")
      expect(page).to have_content("Merchant 2")
      expect(page).to have_content("Merchant 3")
    end

    it "has buttons to disable or enable each merchant" do
      merchant_1 = Merchant.create!(name: "Merchant 1")
      merchant_2 = Merchant.create!(name: "Merchant 2")
      merchant_3 = Merchant.create!(name: "Merchant 3")

      visit "/admin/merchants"

      within("tr#em-#{merchant_1.id}") do
        expect(page).to have_content(merchant_1.name)
        expect(page).to have_button("Disable")
        expect(page).to_not have_button("Enable")
      end
  
      within("tr#em-#{merchant_2.id}") do
        expect(page).to have_content(merchant_2.name)
        expect(page).to have_button("Disable")
        expect(page).to_not have_button("Enable")
      end
  
      within("tr#em-#{merchant_3.id}") do
        expect(page).to have_content(merchant_3.name)
        expect(page).to have_button("Disable")
        expect(page).to_not have_button("Enable")
      end
    end

    it "when clicked redirects to index and the status has changed" do
      merchant_1 = Merchant.create!(name: "Merchant 1")

      visit "/admin/merchants"
      
      click_button("Disable")
      
      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_button("Enable")
    end

    it "has merchants listed in appropriate sections for enabled or disabled" do
      merchant_1 = Merchant.create!(name: "Merchant 1")
      merchant_2 = Merchant.create!(name: "Merchant 2")
      merchant_3 = Merchant.create!(name: "Merchant 3", status: "disabled")
      merchant_4 = Merchant.create!(name: "Merchant 4", status: "disabled")

      visit "/admin/merchants"

      within("tr#em-#{merchant_1.id}") do
        expect(page).to have_content(merchant_1.name)
        expect(page).to_not have_content(merchant_3.name)
        expect(page).to_not have_content(merchant_4.name)
      end

      within("tr#em-#{merchant_2.id}") do
        expect(page).to have_content(merchant_2.name)
        expect(page).to_not have_content(merchant_3.name)
        expect(page).to_not have_content(merchant_4.name)
      end

      within("tr#dm-#{merchant_3.id}") do
        expect(page).to have_content(merchant_3.name)
        expect(page).to_not have_content(merchant_1.name)
        expect(page).to_not have_content(merchant_2.name)
      end

      within("tr#dm-#{merchant_4.id}") do
        expect(page).to have_content(merchant_4.name)
        expect(page).to_not have_content(merchant_1.name)
        expect(page).to_not have_content(merchant_2.name)
      end
    end

    it "creates new merchants" do
      visit "/admin/merchants"

      click_link("Create New Merchant")
      fill_in 'Name', with: "Bob's Ross"

      click_button("Submit")

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("Bob's Ross")
      expect(page).to have_button("Enable")
    end

    it "shows top 5 merchants by total revenue with revenue generated next to each merchant name" do
      merchant_1 = Merchant.create(name: "Merchant 1")
      merchant_2 = Merchant.create(name: "Merchant 2")
      merchant_3 = Merchant.create(name: "Merchant 3")
      merchant_4 = Merchant.create(name: "Merchant 4")
      merchant_5 = Merchant.create(name: "Merchant 5")
      merchant_6 = Merchant.create(name: "Merchant 6") 
      item_1 = Item.create!(name: "Bicycle", description: "It has 2 wheels and pedals.", unit_price: 500, merchant_id: merchant_1.id)
      item_2 = Item.create!(name: "Boot", description: "Goes on foot.", unit_price: 500, merchant_id: merchant_2.id)
      item_3 = Item.create!(name: "Beer", description: "Bubbly.", unit_price: 500, merchant_id: merchant_3.id)
      item_4 = Item.create!(name: "Baseball", description: "Ball.", unit_price: 500, merchant_id: merchant_4.id)
      item_5 = Item.create!(name: "Battleship", description: "Fun game.", unit_price: 500, merchant_id: merchant_5.id)
      item_6 = Item.create!(name: "Boarshead", description: "Sliced meat.", unit_price: 500, merchant_id: merchant_6.id)
      customer_1 = Customer.create!(first_name: "Dan", last_name: "Smith")
      customer_2 = Customer.create!(first_name: "Will", last_name: "Smoth")
      customer_3 = Customer.create!(first_name: "Bill", last_name: "Smyth")
      customer_4 = Customer.create!(first_name: "Dave", last_name: "Smeth")
      customer_5 = Customer.create!(first_name: "Sally", last_name: "Smith")
      customer_6 = Customer.create!(first_name: "Dan", last_name: "Smath")
      customer_7 = Customer.create!(first_name: "Jane", last_name: "Smith")
      invoice_1 = Invoice.create!(status: "completed", customer_id: customer_1.id)
      invoice_2 = Invoice.create!(status: "completed", customer_id: customer_1.id)
      invoice_3 = Invoice.create!(status: "completed", customer_id: customer_1.id)
      invoice_4 = Invoice.create!(status: "completed", customer_id: customer_2.id)
      invoice_5 = Invoice.create!(status: "completed", customer_id: customer_2.id)
      invoice_6 = Invoice.create!(status: "completed", customer_id: customer_2.id)
      invoice_7 = Invoice.create!(status: "completed", customer_id: customer_3.id)
      invoice_8 = Invoice.create!(status: "completed", customer_id: customer_3.id)
      invoice_9 = Invoice.create!(status: "completed", customer_id: customer_4.id)
      invoice_10 = Invoice.create!(status: "completed", customer_id: customer_4.id)
      invoice_11 = Invoice.create!(status: "completed", customer_id: customer_5.id)
      invoice_12 = Invoice.create!(status: "in_progress", customer_id: customer_6.id)
      invoice_13 = Invoice.create!(status: "in_progress", customer_id: customer_7.id)
      invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_2 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_2.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_3 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_3.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_4 = InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice_4.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_5 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_5.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_6 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_6.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_7 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_7.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_8 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_8.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_9 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_9.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_10 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_10.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_11 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_11.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_12 = InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice_12.id, quantity: 5, unit_price: 25000, status: "pending")
      invoice_item_13 = InvoiceItem.create!(item_id: item_6.id, invoice_id: invoice_13.id, quantity: 5, unit_price: 25000, status: "pending")
      transaction_1 = Transaction.create!(invoice_id: invoice_1.id, credit_card_number: "7990276485696308", credit_card_expiration_date: "01/01", result: "success")
      transaction_2 = Transaction.create!(invoice_id: invoice_2.id, credit_card_number: "7990276485696308", credit_card_expiration_date: "01/01", result: "success")
      transaction_3 = Transaction.create!(invoice_id: invoice_3.id, credit_card_number: "7990276485696308", credit_card_expiration_date: "01/01", result: "success")
      transaction_4 = Transaction.create!(invoice_id: invoice_4.id, credit_card_number: "3351425910817706", credit_card_expiration_date: "02/01", result: "success")
      transaction_5 = Transaction.create!(invoice_id: invoice_5.id, credit_card_number: "3351425910817706", credit_card_expiration_date: "02/01", result: "success")
      transaction_6 = Transaction.create!(invoice_id: invoice_6.id, credit_card_number: "3351425910817706", credit_card_expiration_date: "02/01", result: "success")
      transaction_7 = Transaction.create!(invoice_id: invoice_7.id, credit_card_number: "4161047845230560", credit_card_expiration_date: "03/01", result: "success")
      transaction_8 = Transaction.create!(invoice_id: invoice_8.id, credit_card_number: "4161047845230560", credit_card_expiration_date: "03/01", result: "success")
      transaction_9 = Transaction.create!(invoice_id: invoice_9.id, credit_card_number: "9075387155233498", credit_card_expiration_date: "04/01", result: "success")
      transaction_10 = Transaction.create!(invoice_id: invoice_10.id, credit_card_number: "9075387155233498", credit_card_expiration_date: "04/01", result: "success")
      transaction_11 = Transaction.create!(invoice_id: invoice_11.id, credit_card_number: "8154916084080022", credit_card_expiration_date: "05/01", result: "success")
      transaction_12 = Transaction.create!(invoice_id: invoice_12.id, credit_card_number: "1191993766451254", credit_card_expiration_date: "06/01", result: "failed")
      transaction_13 = Transaction.create!(invoice_id: invoice_13.id, credit_card_number: "2079801981307339", credit_card_expiration_date: "07/01", result: "failed")
    
      visit "/admin/merchants"

      expect(page).to have_content("Top 5 Merchants by Revenue")
      expect(merchant_1.name).to appear_before(merchant_2.name)
      expect(merchant_2.name).to appear_before(merchant_3.name)
      expect(merchant_3.name).to appear_before(merchant_4.name)
      expect(merchant_4.name).to appear_before(merchant_5.name)
    end

    it "shows the date with the most revenue for each merchant" do
      merchant_1 = Merchant.create(name: "Merchant 1")
      merchant_2 = Merchant.create(name: "Merchant 2")
      merchant_3 = Merchant.create(name: "Merchant 3")
      merchant_4 = Merchant.create(name: "Merchant 4")
      merchant_5 = Merchant.create(name: "Merchant 5")
      merchant_6 = Merchant.create(name: "Merchant 6") 
      item_1 = Item.create!(name: "Bicycle", description: "It has 2 wheels and pedals.", unit_price: 500, merchant_id: merchant_1.id)
      item_2 = Item.create!(name: "Boot", description: "Goes on foot.", unit_price: 500, merchant_id: merchant_2.id)
      item_3 = Item.create!(name: "Beer", description: "Bubbly.", unit_price: 500, merchant_id: merchant_3.id)
      item_4 = Item.create!(name: "Baseball", description: "Ball.", unit_price: 500, merchant_id: merchant_4.id)
      item_5 = Item.create!(name: "Battleship", description: "Fun game.", unit_price: 500, merchant_id: merchant_5.id)
      item_6 = Item.create!(name: "Boarshead", description: "Sliced meat.", unit_price: 500, merchant_id: merchant_6.id)
      customer_1 = Customer.create!(first_name: "Dan", last_name: "Smith")
      customer_2 = Customer.create!(first_name: "Will", last_name: "Smoth")
      customer_3 = Customer.create!(first_name: "Bill", last_name: "Smyth")
      customer_4 = Customer.create!(first_name: "Dave", last_name: "Smeth")
      customer_5 = Customer.create!(first_name: "Sally", last_name: "Smith")
      customer_6 = Customer.create!(first_name: "Dan", last_name: "Smath")
      customer_7 = Customer.create!(first_name: "Jane", last_name: "Smith")
      invoice_1 = Invoice.create!(status: "completed", customer_id: customer_1.id)
      invoice_2 = Invoice.create!(status: "completed", customer_id: customer_1.id)
      invoice_3 = Invoice.create!(status: "completed", customer_id: customer_1.id)
      invoice_4 = Invoice.create!(status: "completed", customer_id: customer_2.id)
      invoice_5 = Invoice.create!(status: "completed", customer_id: customer_2.id)
      invoice_6 = Invoice.create!(status: "completed", customer_id: customer_2.id)
      invoice_7 = Invoice.create!(status: "completed", customer_id: customer_3.id)
      invoice_8 = Invoice.create!(status: "completed", customer_id: customer_3.id)
      invoice_9 = Invoice.create!(status: "completed", customer_id: customer_4.id)
      invoice_10 = Invoice.create!(status: "completed", customer_id: customer_4.id)
      invoice_11 = Invoice.create!(status: "completed", customer_id: customer_5.id)
      invoice_12 = Invoice.create!(status: "in_progress", customer_id: customer_6.id)
      invoice_13 = Invoice.create!(status: "in_progress", customer_id: customer_7.id)
      invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_2 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_2.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_3 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_3.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_4 = InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice_4.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_5 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_5.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_6 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_6.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_7 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_7.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_8 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_8.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_9 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_9.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_10 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_10.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_11 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_11.id, quantity: 5, unit_price: 25000, status: "shipped")
      invoice_item_12 = InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice_12.id, quantity: 5, unit_price: 25000, status: "pending")
      invoice_item_13 = InvoiceItem.create!(item_id: item_6.id, invoice_id: invoice_13.id, quantity: 5, unit_price: 25000, status: "pending")
      transaction_1 = Transaction.create!(invoice_id: invoice_1.id, credit_card_number: "7990276485696308", credit_card_expiration_date: "01/01", result: "success")
      transaction_2 = Transaction.create!(invoice_id: invoice_2.id, credit_card_number: "7990276485696308", credit_card_expiration_date: "01/01", result: "success")
      transaction_3 = Transaction.create!(invoice_id: invoice_3.id, credit_card_number: "7990276485696308", credit_card_expiration_date: "01/01", result: "success")
      transaction_4 = Transaction.create!(invoice_id: invoice_4.id, credit_card_number: "3351425910817706", credit_card_expiration_date: "02/01", result: "success")
      transaction_5 = Transaction.create!(invoice_id: invoice_5.id, credit_card_number: "3351425910817706", credit_card_expiration_date: "02/01", result: "success")
      transaction_6 = Transaction.create!(invoice_id: invoice_6.id, credit_card_number: "3351425910817706", credit_card_expiration_date: "02/01", result: "success")
      transaction_7 = Transaction.create!(invoice_id: invoice_7.id, credit_card_number: "4161047845230560", credit_card_expiration_date: "03/01", result: "success")
      transaction_8 = Transaction.create!(invoice_id: invoice_8.id, credit_card_number: "4161047845230560", credit_card_expiration_date: "03/01", result: "success")
      transaction_9 = Transaction.create!(invoice_id: invoice_9.id, credit_card_number: "9075387155233498", credit_card_expiration_date: "04/01", result: "success")
      transaction_10 = Transaction.create!(invoice_id: invoice_10.id, credit_card_number: "9075387155233498", credit_card_expiration_date: "04/01", result: "success")
      transaction_11 = Transaction.create!(invoice_id: invoice_11.id, credit_card_number: "8154916084080022", credit_card_expiration_date: "05/01", result: "success")
      transaction_12 = Transaction.create!(invoice_id: invoice_12.id, credit_card_number: "1191993766451254", credit_card_expiration_date: "06/01", result: "failed")
      transaction_13 = Transaction.create!(invoice_id: invoice_13.id, credit_card_number: "2079801981307339", credit_card_expiration_date: "07/01", result: "failed")
    
      visit "/admin/merchants"

      expect(page).to have_content("Top day for #{merchant_1.name} was #{merchant_1.top_selling_date.strftime('%m/%d/%y')}")
      expect(page).to have_content("Top day for #{merchant_2.name} was #{merchant_2.top_selling_date.strftime('%m/%d/%y')}")
      expect(page).to have_content("Top day for #{merchant_3.name} was #{merchant_3.top_selling_date.strftime('%m/%d/%y')}")
      expect(page).to have_content("Top day for #{merchant_4.name} was #{merchant_4.top_selling_date.strftime('%m/%d/%y')}")
      expect(page).to have_content("Top day for #{merchant_5.name} was #{merchant_5.top_selling_date.strftime('%m/%d/%y')}")
    end
  end
end