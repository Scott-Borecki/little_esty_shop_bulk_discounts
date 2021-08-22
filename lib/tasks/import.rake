require 'csv'
require 'faker'

task import: :environment do
  Rake::Task['import:destroy_all'].execute
  Rake::Task['import:customers'].execute
  Rake::Task['import:merchants'].execute
  Rake::Task['import:items'].execute
  Rake::Task['import:invoices'].execute
  Rake::Task['import:invoice_items'].execute
  Rake::Task['import:transactions'].execute
  Rake::Task['import:bulk_discounts'].execute
end

namespace :import do
  task destroy_all: :environment do
    BulkDiscount.destroy_all
    InvoiceItem.destroy_all
    Transaction.destroy_all
    Invoice.destroy_all
    Item.destroy_all
    Customer.destroy_all
    Merchant.destroy_all
  end

  task customers: :environment do
    CSV.foreach('db/data/customers.csv', headers: true) do |row|
      Customer.create!(
        id:         row[0],
        first_name: row[1],
        last_name:  row[2],
        created_at: row[3],
        updated_at: row[4],
        address:    Faker::Address.street_address,
        city:       Faker::Address.city,
        state:      Faker::Address.state,
        zip:        Faker::Address.zip_code.first(5)
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('customers')
  end

  task merchants: :environment do
    CSV.foreach('db/data/merchants.csv', headers: true) do |row|
      Merchant.create!(
        id:         row[0],
        name:       row[1],
        created_at: row[2],
        updated_at: row[3],
        status:     Faker::Number.between(from: 0, to: 1)
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('merchants')
  end

  task items: :environment do
    CSV.foreach('db/data/items.csv', headers: true) do |row|
      Item.create!(
        id:          row[0],
        name:        "#{Faker::Commerce.product_name} (#{Faker::Commerce.color})",
        description: Faker::GreekPhilosophers.quote,
        unit_price:  row[3],
        merchant_id: row[4],
        created_at:  row[5],
        updated_at:  row[6],
        status:      Faker::Number.between(from: 0, to: 1)
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
  end

  task invoices: :environment do
    CSV.foreach('db/data/invoices.csv', headers: true) do |row|
      status = {
        'cancelled'   => 0,
        'in progress' => 1,
        'completed'   => 2
      }
      Invoice.create!(
        id:          row[0],
        customer_id: row[1],
        status:      status[row.to_hash['status']] || Faker::Number.between(from: 0, to: 2),
        created_at:  row[4],
        updated_at:  row[5]
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
  end

  task transactions: :environment do
    CSV.foreach('db/data/transactions.csv', headers: true) do |row|
      result = {
        'failed'  => 0,
        'success' => 1
      }
      Transaction.create!(
        id:                          row[0],
        invoice_id:                  row[1],
        credit_card_number:          row[2],
        credit_card_expiration_date: row[3] || Faker::Number.decimal_part(digits: 4),
        result:                      result[row.to_hash['result']] || Faker::Number.between(from: 0, to: 1),
        created_at:                  row[5],
        updated_at:                  row[6]
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
  end

  task invoice_items: :environment do
    CSV.foreach('db/data/invoice_items.csv', headers: true) do |row|
      status = {
        'pending'  => 0,
        'packaged' => 1,
        'shipped'  => 2
      }
      InvoiceItem.create!(
        id:         row[0],
        item_id:    row[1],
        invoice_id: row[2],
        quantity:   row[3],
        unit_price: row[4],
        status:     status[row.to_hash['status']] || Faker::Number.between(from: 0, to: 2),
        created_at: row[6],
        updated_at: row[7]
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  end

  task bulk_discounts: :environment do
    200.times do
      BulkDiscount.create!(
        merchant: Merchant.all.sample,
        percentage_discount: Faker::Number.between(from: 1, to: 80),
        quantity_threshold: Faker::Number.between(from: 2, to: 9)
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('bulk_discounts')
  end
end
