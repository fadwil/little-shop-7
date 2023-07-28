require "rails_helper"

RSpec.describe Invoice, type: :model do
  test_csv_load
  before(:each) do
    @invoice_1 = Invoice.first
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end

    it "can format the created_at date of an invoice" do
      expect(@invoice_1.format_created_at).to eq("Sunday, March 25, 2012")
    end
  end
end