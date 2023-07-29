require "rails_helper"

RSpec.describe Merchant, type: :model do
  test_csv_load
  before(:each) do

    @merchant_1 = Merchant.first
    @merchant_2 = Merchant.find(2)
    @merchant_1_items = Item.find(1,2,3,4,6,9,10,12,15)
    @merchant_2_items = Item.find(17,18,19,20,21,22,23,24,26,29,30,32,35,37,38,39,40)
    
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
  end
end