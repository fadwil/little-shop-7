require 'csv'

namespace :csv_load do

  desc "All"
  task all: [:customers, :merchants, :invoices, :items, :invoice_items, :transactions] do
    
  end

  desc "TODO"
  task customers: :environment do
    csv_text = File.read("db/data/customers.csv")
    csv = CSV.parse(csv_text, :headers => true, header_converters: :symbol)
    csv.each do |row|
      Customer.create(row)
    end
    
  end

  desc "TODO"
  task invoice_items: :environment do 
    csv_text = File.read("db/data/invoice_items.csv")
    csv = CSV.parse(csv_text, :headers => true, header_converters: :symbol)
    csv.each do |row|
      InvoiceItem.create(row)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  end

  desc "TODO"
  task invoices: :environment do    
    csv_text = File.read("db/data/invoices.csv")
    csv = CSV.parse(csv_text, :headers => true, header_converters: :symbol)
    csv.each do |row|
      Invoice.create(row)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
  end

  desc "TODO"
  task items: :environment do    
    csv_text = File.read("db/data/items.csv")
    csv = CSV.parse(csv_text, :headers => true, header_converters: :symbol)
    csv.each do |row|
      Item.create(row)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
  end

  desc "TODO"
  task merchants: :environment do    
    csv_text = File.read("db/data/merchants.csv")
    csv = CSV.parse(csv_text, :headers => true, header_converters: :symbol)
    csv.each do |row|
      Merchant.create(row)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('merchants')
  end

  desc "TODO"
  task transactions: :environment do    
    csv_text = File.read("db/data/transactions.csv")
    csv = CSV.parse(csv_text, :headers => true, header_converters: :symbol)
    csv.each do |row|
      Transaction.create(row)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
  end
end
