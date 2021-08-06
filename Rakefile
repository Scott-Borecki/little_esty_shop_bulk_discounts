# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :csv_load do
  task destroy_all: :environment do
    InvoiceItem.destroy_all
    Transaction.destroy_all
    Invoice.destroy_all
    Item.destroy_all
    Customer.destroy_all
    Merchant.destroy_all
  end

  task customers: :environment do
    ActiveRecord::Base.connection.reset_pk_sequence!('customers')
    CSV.foreach('db/data/customers.csv', headers: true, header_converters: :symbol) do |row|
      Customer.create!(row.to_h)
    end
  end

  task invoice_items: :environment do
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
    CSV.foreach('db/data/invoice_items.csv', headers: true, header_converters: :symbol) do |row|
      InvoiceItem.create!(row.to_h)
    end
  end

  task invoices: :environment do
    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
    CSV.foreach('db/data/invoices.csv', headers: true, header_converters: :symbol) do |row|
      Invoice.create!(row.to_h)
    end
  end

  task items: :environment do
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
    CSV.foreach('db/data/items.csv', headers: true, header_converters: :symbol) do |row|
      Item.create!(row.to_h)
    end
  end

  task merchants: :environment do
    ActiveRecord::Base.connection.reset_pk_sequence!('merchants')
    CSV.foreach('db/data/merchants.csv', headers: true, header_converters: :symbol) do |row|
      Merchant.create!(row.to_h)
    end
  end

  task transactions: :environment do
    ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
    CSV.foreach('db/data/transactions.csv', headers: true, header_converters: :symbol) do |row|
      Transaction.create!(row.to_h)
    end
  end

  task all: [:destroy_all, :merchants, :customers, :items, :invoices, :invoice_items, :transactions]
end
