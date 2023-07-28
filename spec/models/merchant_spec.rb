require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :items }
    it { should have_many(:invoices).through(:items) }
  end

  describe "instance methods" do
  
    describe '#customers' do
      it 'returns the customers for a merchant' do
        expect 
      end
    end
  
  
  
  
  
  
  end
end