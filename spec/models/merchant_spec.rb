require "rails_helper"

RSpec.describe Merchant, type: :model do
  test_csv_load
  before(:each) do

    @merchant_1 = Merchant.first
    @merchant_2 = Merchant.find(2)
    @merchant_1_items = Item.find(15,9,10,12,1,2,3,4,6)
    @merchant_2_items = Item.find(37,38,39,40,35,26,29,17,18,19,20,30,32,21,22,23,24)
    @top_customers_test = Customer.find(3,2,4,1,5)
    
  end
  describe "relationships" do
    it { should have_many :items }
    it { should have_many(:invoices).through(:items) }
  end

  describe 'instance methods' do
    describe '#items_status' do
      it 'returns all items that havent been shipped' do
        expect(@merchant_1.items_status).to eq(@merchant_1_items)
        expect(@merchant_2.items_status).to eq(@merchant_2_items)
      end
    end

    describe '#top_customers' do
      it 'returns the top 5 customers for a merchant' do

        top_customers_test_csv_load
        @top_customers = Merchant.find(1).top_customers
        @top_customers_test = Customer.find(170, 7, 103, 119, 73,)

        expect(@top_customers.find(7)).to eq(Customer.find(7))
        expect(@top_customers.find(170)).to eq(Customer.find(170))
        expect(@top_customers.find(103)).to eq(Customer.find(103))
        expect(@top_customers.find(119)).to eq(Customer.find(119))
        expect(@top_customers.find(73)).to eq(Customer.find(73))
          
      end
    end
  end
end