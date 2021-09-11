require 'rails_helper'

describe Merchant do
  describe 'validations' do
    it { should define_enum_for(:status).with_values(enabled: 0, disabled: 1) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }

    it 'is valid with valid attributes' do
      merchant = create(:merchant)
      expect(merchant).to be_valid

      enabled_merchant = create(:enabled_merchant)
      expect(enabled_merchant).to be_valid

      disabled_merchant = create(:disabled_merchant)
      expect(disabled_merchant).to be_valid
    end
  end

  describe 'delegations' do
    it { should delegate_method(:top_customers).to(:customers) }
    it { should delegate_method(:ready_to_ship).to(:invoice_items).with_prefix }
    it { should delegate_method(:total_revenue).to(:invoice_items).with_prefix }
    it { should delegate_method(:revenue_discount).to(:invoice_items).with_prefix }
    it { should delegate_method(:total_discounted_revenue).to(:invoice_items).with_prefix }
    it { should delegate_method(:top_revenue_day).to(:invoices) }
    it { should delegate_method(:top_items).to(:items) }
    it { should delegate_method(:total_items_sold).to(:items) }
  end

  describe 'relationships' do
    it { should have_many(:bulk_discounts) }
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'class methods' do
    # See /spec/sample_data/create_objects.rb for more info on factories created
    create_objects

    describe '.top_merchants_by_revenue' do
      it 'returns the top merchants by revenue' do
        top_five_merchants = [merchant3, merchant6, merchant5, merchant2, merchant4]

        expect(Merchant.top_merchants_by_revenue.to_a.size).to eq(5)
        expect(Merchant.top_merchants_by_revenue).to eq(top_five_merchants)

        expect(Merchant.top_merchants_by_revenue(2).to_a.size).to eq(2)
      end

      it 'returns the revenue of each top merchant' do
        top_five_merchants_revenue = [710, 680, 150, 140, 130]

        expect(Merchant.top_merchants_by_revenue.map(&:total_revenue)).to eq(top_five_merchants_revenue)
      end
    end
  end
end
