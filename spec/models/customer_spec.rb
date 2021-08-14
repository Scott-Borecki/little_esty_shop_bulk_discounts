require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_numericality_of(:zip) }
    it { should validate_length_of(:zip).is_equal_to(5) }

    it 'is valid with valid attributes' do
      customer = create(:customer)
      expect(customer).to be_valid
    end
  end

  describe 'relationships' do
    it { should have_many(:invoices) }
    it { should have_many(:merchants).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'class methods' do
    describe '.top_customers_by_transactions' do
      # See /spec/object_creation_helper.rb for more info on factories created
      create_objects_merchant_with_many_customers_and_items

      it 'returns the top customers' do
        top_five_customers = [customer3, customer4, customer2, customer7, customer8]

        expect(Customer.top_customers_by_transactions.to_a.size).to eq(5)
        expect(Customer.top_customers_by_transactions).to eq(top_five_customers)

        expect(Customer.top_customers_by_transactions(2).to_a.size).to eq(2)
      end
    end
  end

  describe 'instance methods' do
    describe '#full_name' do
      it 'returns the full name of the customer' do
        customer = create(:customer)
        expected = "#{customer.first_name} #{customer.last_name}"
        expect(customer.full_name).to eq(expected)
      end
    end

    describe '#city_state_zip' do
      it 'returns the city, state, and zip code of the customer' do
        customer = create(:customer)
        expected = "#{customer.city}, #{customer.state} #{customer.zip}"
        expect(customer.city_state_zip).to eq(expected)
      end
    end
  end
end
