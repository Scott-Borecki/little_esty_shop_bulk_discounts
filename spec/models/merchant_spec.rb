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
        top_five_merchants_revenue = [710, 680, 150, 140, 130]

        expect(Merchant.top_merchants_by_revenue.to_a.size).to eq(5)
        expect(Merchant.top_merchants_by_revenue).to eq(top_five_merchants)
        expect(Merchant.top_merchants_by_revenue.map(&:revenue)).to eq(top_five_merchants_revenue)

        expect(Merchant.top_merchants_by_revenue(2).to_a.size).to eq(2)
      end
    end
  end

  describe 'instance methods' do
    describe '#top_revenue_day' do
      it 'returns the best day by revenue' do
        merchant = create(:enabled_merchant)

        customer = create(:customer)

        item6 = create(:item, merchant: merchant)
        item6a = create(:item, merchant: merchant)

        invoice6a = create(:invoice, :completed, customer: customer, created_at: "2021-07-29T17:30:05+0700")
        invoice6b = create(:invoice, :completed, customer: customer, created_at: "2021-07-27T17:30:05+0700")
        invoice6c = create(:invoice, :completed, customer: customer, created_at: "2021-07-25T17:30:05+0700")

        create(:transaction, :success, invoice: invoice6a)
        create(:transaction, :success, invoice: invoice6b)
        create(:transaction, :success, invoice: invoice6c)

        create(:invoice_item, :shipped,  item: item6,  invoice: invoice6a, quantity: 6,  unit_price: 10)
        create(:invoice_item, :shipped,  item: item6a, invoice: invoice6a, quantity: 5,  unit_price: 20)
        create(:invoice_item, :shipped,  item: item6,  invoice: invoice6b, quantity: 6,  unit_price: 10)
        create(:invoice_item, :shipped,  item: item6a, invoice: invoice6b, quantity: 10, unit_price: 20)
        create(:invoice_item, :shipped,  item: item6,  invoice: invoice6c, quantity: 6,  unit_price: 10)
        create(:invoice_item, :shipped,  item: item6a, invoice: invoice6c, quantity: 10, unit_price: 20)

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
  end

  # describe "instance methods" do
  #   before :each do
  #     @merchant1 = Merchant.create!(name: 'Hair Care')
  #     @merchant2 = Merchant.create!(name: 'Jewelry')
  #
  #     @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
  #     @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
  #     @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
  #     @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
  #     @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
  #     @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
  #
  #     @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
  #     @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)
  #
  #     @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
  #     @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
  #     @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
  #     @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
  #     @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
  #     @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')
  #
  #     @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
  #     @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
  #     @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
  #     @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
  #     @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
  #     @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
  #     @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)
  #
  #     @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0, created_at: "2012-03-27 14:54:09")
  #     @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")
  #     @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2, created_at: "2012-03-28 14:54:09")
  #     @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1, created_at: "2012-03-30 14:54:09")
  #     @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-01 14:54:09")
  #     @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1, created_at: "2012-04-02 14:54:09")
  #     @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1, created_at: "2012-04-03 14:54:09")
  #     @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
  #
  #     @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
  #     @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
  #     @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
  #     @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
  #     @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
  #     @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
  #     @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
  #   end
  #
  #   it "can list items ready to ship" do
  #     expect(@merchant1.ordered_items_to_ship).to eq([@item_1, @item_3, @item_4, @item_7, @item_8])
  #   end
  #
  #   it "top_5_items" do
  #     expect(@merchant1.top_5_items).to eq([@item_1, @item_2, @item_3, @item_8, @item_4])
  #   end
  # end
end
