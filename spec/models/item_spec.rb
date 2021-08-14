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
    describe '.top_customers_by_transactions' do
      # See /spec/object_creation_helper.rb for more info on factories created
      create_objects_merchant_with_many_customers_and_items

      it 'returns the top customers by number of transactions' do
        top_customers             = [customer3, customer4, customer2, customer7, customer8]
        top_customer_ids          = top_customers.map(&:id)
        top_customer_first_names  = top_customers.map(&:first_name)
        top_customer_last_names   = top_customers.map(&:last_name)
        top_customer_transactions = [5, 4, 3, 2, 2]

        expect(Item.top_customers_by_transactions.to_a.size).to eq(5)
        expect(Item.top_customers_by_transactions(2).to_a.size).to eq(2)
        expect(Item.top_customers_by_transactions.map(&:id)).to eq(top_customer_ids)
        expect(Item.top_customers_by_transactions.map(&:first_name)).to eq(top_customer_first_names)
        expect(Item.top_customers_by_transactions.map(&:last_name)).to eq(top_customer_last_names)
        expect(Item.top_customers_by_transactions.map(&:number_transactions)).to eq(top_customer_transactions)
      end
    end

    describe '.top_items_by_revenue' do
      # See /spec/object_creation_helper.rb for more info on factories created
      create_objects_merchant_with_many_customers_and_items

      it 'returns the top items by revenue' do
        top_five_items = [item5, item18, item8, item12, item15]
        top_five_items_revenue = [250, 240, 210, 200, 180]

        expect(Item.top_items_by_revenue.to_a.size).to eq(5)
        expect(Item.top_items_by_revenue(2).to_a.size).to eq(2)
        expect(Item.top_items_by_revenue).to eq(top_five_items)
        expect(Item.top_items_by_revenue.map(&:total_revenue)).to eq(top_five_items_revenue)
      end
    end
  end

  describe 'delegated methods' do
    describe '#top_revenue_day' do
      # See /spec/object_creation_helper.rb for more info on factories created
      create_objects_top_revenue_day

      it 'returns the best day by revenue and most recent' do
        expect(item1.top_revenue_day).to eq(invoice2.formatted_date)
      end
    end
  end
end
