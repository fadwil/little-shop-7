require "rails_helper"

RSpec.describe "/admin/invoices" do
  describe "When I visit the admin invoices index" do
    before do
      @customer_1 = Customer.create!(first_name: "Dan", last_name: "Smith")
      @customer_2 = Customer.create!(first_name: "Will", last_name: "Smoth")
      @customer_3 = Customer.create!(first_name: "Bill", last_name: "Smyth")
      @customer_4 = Customer.create!(first_name: "Dave", last_name: "Smeth")
      @customer_5 = Customer.create!(first_name: "Sally", last_name: "Smith")
      @customer_6 = Customer.create!(first_name: "Dan", last_name: "Smath")
      @customer_7 = Customer.create!(first_name: "Jane", last_name: "Smith")
      @invoice_1 = Invoice.create!(status: "completed", customer_id: @customer_1.id)
      @invoice_2 = Invoice.create!(status: "completed", customer_id: @customer_2.id)
      @invoice_3 = Invoice.create!(status: "completed", customer_id: @customer_3.id)
      @invoice_4 = Invoice.create!(status: "completed", customer_id: @customer_4.id)
      @invoice_5 = Invoice.create!(status: "completed", customer_id: @customer_5.id)
      @invoice_6 = Invoice.create!(status: "completed", customer_id: @customer_6.id)
      @invoice_7 = Invoice.create!(status: "completed", customer_id: @customer_7.id)

      visit "/admin/invoices"
    end

    it 'I see a list of all Invoice ids in the system and each id links to the show page' do
      expect(page).to have_link("#{@invoice_1.id}")
      expect(page).to have_link("#{@invoice_2.id}")
      expect(page).to have_link("#{@invoice_3.id}")
      expect(page).to have_link("#{@invoice_4.id}")
      expect(page).to have_link("#{@invoice_5.id}")
      expect(page).to have_link("#{@invoice_6.id}")
      expect(page).to have_link("#{@invoice_7.id}")
    end
  end
end