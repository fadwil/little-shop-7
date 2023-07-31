require "rails_helper"

RSpec.describe Invoice, type: :model do
  test_csv_load
  before(:each) do
    @invoice_1 = Invoice.first
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  end

  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe "instance methods" do
    
    it "can format the created_at date of an invoice" do
      invoice = Invoice.create!(customer_id: 3, status: "completed", created_at: "2012-03-25 09:54:09 UTC")
      expect(invoice.format_created_at).to eq("Sunday, March 25, 2012")
    end

    it "can determine if any transactions were successful" do
      invoice = Invoice.create!(customer_id: 3, status: "completed", created_at: "2012-03-25 09:54:09 UTC")
      expect(invoice.transactions_successful?).to eq false
      transaction = invoice.transactions.create!(result: "success")
      expect(invoice.transactions_successful?).to eq true
    end
  end
end