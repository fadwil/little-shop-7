require "rails_helper"

RSpec.describe Customer, type: :model do

  test_csv_load

  before(:each) do
    @merchant_1 = Merchant.first
    @customer_1 = Customer.find(1)
    @customer_2 = Customer.find(2)
    @customer_3 = Customer.find(3)
    @customer_4 = Customer.find(4)
    @customer_5 = Customer.find(5)
  end
  describe "relationships" do
    it { should have_many :invoices }
  end


  describe "class_methods" do
    describe "#top_customers_for_merchant(merchant_id)" do
      
      xit "returns the top 5 customers for a given merchant id" do
        # binding.pry;
        expect(@merchant_1.top_customers).to eq([@customer_1, @customer_2, @customer_3, @customer_4, @customer_5])
      end
    end
  end
end