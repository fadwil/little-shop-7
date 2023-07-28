require "rails_helper"

RSpec.describe Customer, type: :model do
  test_csv_load
  before(:each) do
    @customer_1 = Customer.first
  end
  describe "relationships" do
    it { should have_many :invoices }
  end

  describe '#successful_transactions_count' do
    it 'Returns the transactions from a given customer' do
      expect(@customer_1.successful_transactions_count).to eq()
    end
  end
end