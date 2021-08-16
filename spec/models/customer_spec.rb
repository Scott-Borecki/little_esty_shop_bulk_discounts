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
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
  end

  describe 'class methods' do
    describe '.top_customers' do
      # See /spec/sample_data/create_objects_merchant_with_many_customers_and_items.rb for more info on factories created
      create_objects_merchant_with_many_customers_and_items

      it 'returns and orders the top customers by most transactions (default)' do
        top_by_transactions   = [customer3, customer4, customer2, customer7, customer8]
        top_transaction_count = [5, 4, 3, 2, 2]

        actual = Customer.top_customers
        expect(actual.length).to eq(5)
        expect(actual).to eq(top_by_transactions)
        expect(actual.map(&:transaction_count)).to eq(top_transaction_count)

        actual = Customer.top_customers(2)
        expect(actual.length).to eq(2)
      end

      it 'returns and orders the top customer by total revenue generated' do
        top_by_total_revenue = [customer3, customer2, customer4, customer8, customer7]
        top_total_revenue    = [599, 490, 480, 400, 340]

        actual = Customer.top_customers(5, 'total_revenue', 'desc')
        expect(actual.length).to eq(5)
        expect(actual).to eq(top_by_total_revenue)
        expect(actual.map(&:total_revenue)).to eq(top_total_revenue)
      end

      it 'returns and orders the top customer by total items bought' do
        top_by_total_items = [customer3, customer4, customer2, customer8, customer7]
        top_total_items    = [39, 32, 29, 27, 24]

        actual = Customer.top_customers(5, 'total_items', 'desc')
        expect(actual.length).to eq(5)
        expect(actual).to eq(top_by_total_items)
        expect(actual.map(&:total_items)).to eq(top_total_items)
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
