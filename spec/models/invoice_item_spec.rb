require "rails_helper"

RSpec.describe InvoiceItem, type: :model do
  test_csv_load
  before(:each) do
    @invoice_1 = InvoiceItem.first
    @invoice_2 = InvoiceItem.find(2)
    @invoice_3 = InvoiceItem.find(3)
  end
  describe "relationships" do
    it { should belong_to :item }
    it { should belong_to :invoice }
  end

  describe "enums" do
    it 'Has a enum for its status' do
      expect(@invoice_1.status).to eq(2)
      expect(@invoice_2.status).to eq(0)
      expect(@invoice_3.status).to eq(1)
    end
  end
end