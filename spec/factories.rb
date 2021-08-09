require 'faker'

FactoryBot.define do
  factory :bulk_discount do
    percentage_discount { sample(0..30) }
    quantity_threshold  { sample(10..30) }
    merchant
  end

  factory :customer do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    address    { Faker::Address.street_address }
    city       { Faker::Address.city }
    state      { Faker::Address.state }
    zip        { Faker::Address.zip_code.first(5) }
  end

  factory :invoice do
    status { rand(0..2) }
    customer
  end

  factory :item do
    name        { Faker::Name.name }
    description { Faker::Movies::LordOfTheRings.location }
    unit_price  { Faker::Number.binary(digits: 5) }
    merchant

    factory :enabled_item do
      status { :enabled }
    end

    factory :disabled_item do
      status { :disabled }
    end
  end

  factory :invoice_item do
    quantity   { rand(20) }
    unit_price { rand(999) }
    status     { rand(0..2) }
    invoice
    item
  end

  factory :merchant do
    name { Faker::Name.name }

    factory :enabled_merchant do
      status { :enabled }
    end

    factory :disabled_merchant do
      status { :disabled }
    end
  end

  factory :transaction do
    credit_card_number          { Faker::Business.credit_card_number.delete('-') }
    credit_card_expiration_date { Faker::Number.decimal_part(digits: 4) }
    result                      { rand(0..1) }
    invoice
  end
end
