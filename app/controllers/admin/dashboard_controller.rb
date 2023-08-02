class Admin::DashboardController < ApplicationController

  def index
    @top_customers = Customer.top_customers_with_transactions
    @incomplete_invoices = Invoice.unshipped_invoices
    
  end

end
