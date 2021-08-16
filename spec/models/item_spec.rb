require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should define_enum_for(:status).with_values(disabled: 0, enabled: 1) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price) }

    it 'is valid with valid attributes' do
      item = create(:item)
      expect(item).to be_valid

      enabled_item = create(:enabled_item)
      expect(enabled_item).to be_valid

      disabled_item = create(:disabled_item)
      expect(disabled_item).to be_valid
    end
  end

  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'class methods' do
    describe '.top_items' do
      # See /spec/sample_data/create_objects_merchant_with_many_customers_and_items.rb for more info on factories created
      create_objects_merchant_with_many_customers_and_items

      it 'returns and orders the top items by total revenue (default)' do
        top_five_items = [item5, item18, item8, item12, item15]
        top_five_items_revenue = [250, 240, 210, 200, 180]

        actual = Item.top_items
        expect(actual.to_a.size).to eq(5)
        expect(actual).to eq(top_five_items)
        expect(actual.map(&:total_revenue)).to eq(top_five_items_revenue)

        actual = Item.top_items(number: 2)
        expect(actual.to_a.size).to eq(2)
      end

      it 'returns and orders the top items by most transactions' do
        top_by_transactions   = [item9, item12, item15]
        top_transaction_count = [4, 3, 2]

        actual = Item.top_items(order_attribute: 'transaction_count')
        expect(actual.length).to eq(5)

        actual = Item.top_items(number: 3, order_attribute: 'transaction_count')
        expect(actual.length).to eq(3)
        expect(actual).to eq(top_by_transactions)
        expect(actual.map(&:transaction_count)).to eq(top_transaction_count)
      end

      it 'returns and orders the top items by most bought' do
        top_by_total_items = [item18, item8, item5, item12, item15]
        top_total_items    = [16, 15, 15, 14, 13]

        actual = Item.top_items(order_attribute: 'total_items')
        expect(actual.length).to eq(5)
        expect(actual).to eq(top_by_total_items)
        expect(actual.map(&:total_items)).to eq(top_total_items)
      end
    end
  end

  describe 'delegated methods' do
    describe '#top_revenue_day' do
      # See /spec/sample_data/create_objects_top_revenue_day.rb for more info on factories created
      create_objects_top_revenue_day

      it 'returns the best day by revenue and most recent' do
        expect(item1.top_revenue_day).to eq(invoice2.formatted_date)
      end
    end

    describe '#top_customers' do
      # See /spec/sample_data/create_objects_item_with_many_customers.rb for more info on factories created
      create_objects_item_with_many_customers

      it 'returns the top customers by number of transactions' do
        top_customers             = [customer3, customer4, customer2, customer7, customer8]
        top_customer_ids          = top_customers.map(&:id)
        top_customer_first_names  = top_customers.map(&:first_name)
        top_customer_last_names   = top_customers.map(&:last_name)
        top_customer_transactions = [5, 4, 3, 2, 2]

        expect(item1.top_customers.to_a.size).to eq(5)
        expect(item1.top_customers(limit: 2).to_a.size).to eq(2)
        expect(item1.top_customers.map(&:id)).to eq(top_customer_ids)
        expect(item1.top_customers.map(&:first_name)).to eq(top_customer_first_names)
        expect(item1.top_customers.map(&:last_name)).to eq(top_customer_last_names)
        expect(item1.top_customers.map(&:transaction_count)).to eq(top_customer_transactions)
      end
    end
  end
end
