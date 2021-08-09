require 'rails_helper'

describe Merchant do
  describe "validations" do
    it { should validate_presence_of :name }
  end

  describe "relationships" do
    it { should have_many(:bulk_discounts) }
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'class methods' do
    # See /spec/factories.rb for more info on factories created
    create_factories

    describe '.top_merchants_by_revenue' do
      it 'returns the top merchants by revenue' do
        top_five_merchants = [merchant3, merchant6, merchant5, merchant2, merchant4]

        expect(Merchant.top_merchants_by_revenue.to_a.size).to eq(5)
        expect(Merchant.top_merchants_by_revenue).to eq(top_five_merchants)

        expect(Merchant.top_merchants_by_revenue(2).to_a.size).to eq(2)
      end

      it 'returns the revenue of each top merchant' do
        top_five_merchants_revenue = [710, 680, 150, 140, 130]

        expect(Merchant.top_merchants_by_revenue.map(&:revenue)).to eq(top_five_merchants_revenue)
      end
    end
  end

  describe 'instance methods' do
    describe '#top_revenue_day' do
      # See /spec/factories.rb for more info on factories created
      create_objects_top_revenue_day

      it 'returns the best day by revenue' do
        expect(merchant.top_revenue_day).to eq("Tuesday, July 27, 2021")
      end
    end

    describe '#top_customers_by_transactions' do
      # See /spec/factories.rb for more info on factories created
      create_factories_merchant_with_many_customers_and_items

      it 'returns the top customers by number of transactions' do
        top_customer_ids = [customer3.id, customer4.id, customer2.id, customer7.id, customer8.id]
        top_customer_first_names = [customer3.first_name, customer4.first_name, customer2.first_name, customer7.first_name, customer8.first_name]
        top_customer_last_names = [customer3.last_name, customer4.last_name, customer2.last_name, customer7.last_name, customer8.last_name]
        top_customer_transactions = [5, 4, 3, 2, 2]

        expect(merchant.top_customers_by_transactions.to_a.size).to eq(5)
        expect(merchant.top_customers_by_transactions(2).to_a.size).to eq(2)
        expect(merchant.top_customers_by_transactions.map(&:id)).to eq(top_customer_ids)
        expect(merchant.top_customers_by_transactions.map(&:first_name)).to eq(top_customer_first_names)
        expect(merchant.top_customers_by_transactions.map(&:last_name)).to eq(top_customer_last_names)
        expect(merchant.top_customers_by_transactions.map(&:number_transactions)).to eq(top_customer_transactions)
      end
    end

    describe '#top_items_by_revenue' do
      # See /spec/factories.rb for more info on factories created
      create_factories_merchant_with_many_customers_and_items

      it 'returns the top items by revenue' do
        top_five_items = [item5, item18, item8, item12, item15]
        top_five_items_revenue = [250, 240, 210, 200, 180]

        expect(merchant.top_items_by_revenue.to_a.size).to eq(5)
        expect(merchant.top_items_by_revenue(2).to_a.size).to eq(2)
        expect(merchant.top_items_by_revenue).to eq(top_five_items)
        expect(merchant.top_items_by_revenue.map(&:total_revenue)).to eq(top_five_items_revenue)
      end
    end

    describe '#items_ready_to_ship' do
      # See /spec/factories.rb for more info on factories created
      create_factories_merchant_with_many_customers_and_items

      before do
        @invoice_items_to_ship = [invoice_item3d_1, invoice_item6a_2, invoice_item4c_1,
                                  invoice_item10a_1, invoice_item3e_1, invoice_item4b_2,
                                  invoice_item3b_1, invoice_item3b_2, invoice_item7b_1,
                                  invoice_item7a_2, invoice_item1a_1, invoice_item1a_2,
                                  invoice_item8a_1, invoice_item8a_2]
      end

      it 'returns the invoice and item ids for each item ready to ship' do
        expect(merchant.items_ready_to_ship.map(&:invoice_id)).to eq(@invoice_items_to_ship.map(&:invoice_id))
        expect(merchant.items_ready_to_ship.map(&:item_id)).to eq(@invoice_items_to_ship.map(&:item_id))
      end

      it 'returns the item name for each item ready to ship' do
        item_names =
          @invoice_items_to_ship.map do |invoice_item|
            Item.find(invoice_item.item_id).name
          end

        expect(merchant.items_ready_to_ship.map(&:item_name)).to eq(item_names)
      end

      it 'returns the invoice creation date for each item ready to ship ordered by creation date' do
        invoice_created_at =
          @invoice_items_to_ship.map do |invoice_item|
            Invoice.find(invoice_item.invoice_id).created_at
          end

        expect(merchant.items_ready_to_ship.map(&:invoice_created_at)).to eq(invoice_created_at)
      end
    end
  end
end
