require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should define_enum_for(:status).with_values(cancelled: 0, 'in progress': 1, completed: 2) }
    it { should validate_presence_of(:status) }
  end

  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:transactions) }
  end

  describe 'class methods' do
    describe '.best_day' do
      let!(:merchant1) { create(:merchant) }
      let!(:merchant2) { create(:merchant) }

      let!(:item1) { create(:item, merchant: merchant1, status: 1) }
      let!(:item2) { create(:item, merchant: merchant1) }
      let!(:item3) { create(:item, merchant: merchant1) }
      let!(:item4) { create(:item, merchant: merchant1) }
      let!(:item7) { create(:item, merchant: merchant1) }
      let!(:item8) { create(:item, merchant: merchant1) }

      let!(:item5) { create(:item, merchant: merchant2) }
      let!(:item6) { create(:item, merchant: merchant2) }

      let!(:invoice1) { create(:invoice, status: 2, created_at: "2012-03-27 14:54:09") }
      let!(:invoice2) { create(:invoice, status: 2, created_at: "2012-03-28 14:54:09") }
      let!(:invoice3) { create(:invoice, status: 2) }
      let!(:invoice4) { create(:invoice, status: 2) }
      let!(:invoice5) { create(:invoice, status: 2) }
      let!(:invoice6) { create(:invoice, status: 2) }
      let!(:invoice7) { create(:invoice, status: 1) }

      let!(:ii1) { create(:invoice_item, invoice: invoice1, item: item1, quantity: 9, unit_price: 10099, status: 2, created_at: "2012-03-27 14:54:09") }
      let!(:ii2) { create(:invoice_item, invoice: invoice2, item: item1, quantity: 9, unit_price: 10099, status: 2, created_at: "2012-03-28 14:54:09") }
      let!(:ii3) { create(:invoice_item, invoice: invoice3, item: item2, quantity: 2, unit_price: 8099,  status: 2) }
      let!(:ii4) { create(:invoice_item, invoice: invoice4, item: item3, quantity: 3, unit_price: 5099,  status: 1) }
      let!(:ii6) { create(:invoice_item, invoice: invoice5, item: item4, quantity: 1, unit_price: 1099,  status: 1) }
      let!(:ii7) { create(:invoice_item, invoice: invoice6, item: item7, quantity: 1, unit_price: 3099,  status: 1) }
      let!(:ii8) { create(:invoice_item, invoice: invoice7, item: item8, quantity: 1, unit_price: 5099,  status: 1) }
      let!(:ii9) { create(:invoice_item, invoice: invoice7, item: item4, quantity: 1, unit_price: 1099,  status: 1) }

      let!(:transaction1) { create(:transaction, result: 1, invoice: invoice1) }
      let!(:transaction2) { create(:transaction, result: 1, invoice: invoice2) }
      let!(:transaction3) { create(:transaction, result: 1, invoice: invoice3) }
      let!(:transaction4) { create(:transaction, result: 1, invoice: invoice4) }
      let!(:transaction5) { create(:transaction, result: 1, invoice: invoice5) }
      let!(:transaction6) { create(:transaction, result: 0, invoice: invoice6) }
      let!(:transaction7) { create(:transaction, result: 1, invoice: invoice7) }

      it 'returns the date of the invoice with the most revenue' do
        expect(Invoice.best_day).to eq(invoice2.formatted_date)
      end
    end

    describe '.incomplete_invoices' do
      # See /spec/object_creation_helper.rb for more info on factories created
      create_factories

      let(:invoices_not_shipped) { [invoice5a, invoice5b, invoice3, invoice1] }

      it 'returns all the incomplete invoices (i.e. not shipped) ordered by oldest to newest' do
        expect(Invoice.incomplete_invoices).to eq(invoices_not_shipped)
      end

      it 'returns all the ids of the incomplete invoices (i.e. not shipped)' do
        expect(Invoice.incomplete_invoices.first.id).to eq(invoices_not_shipped.first.id)
      end

      it 'returns all the invoice dates of the incomplete invoices (i.e. not shipped)' do
        expect(Invoice.incomplete_invoices.first.formatted_date).to eq(invoices_not_shipped.first.formatted_date)
      end
    end
  end

  describe 'instance methods' do
    # See spec/object_creation_helper.rb for objection creation details
    create_factories

    describe '#total_revenue' do
      it 'returns the total revenue' do
        expect(invoice1.total_revenue).to eq(500)
        expect(invoice3.total_revenue).to eq(710)
      end
    end

    describe '#invoice_items_discounted' do
      it 'returns the items qualifying for a bulk discount' do
        expect(invoice1.invoice_items_discounted.length).to eq(1)
        expect(invoice1.invoice_items_discounted.ids).to eq([invoice_item1b.id])

        expect(invoice3.invoice_items_discounted.length).to eq(2)
        expect(invoice3.invoice_items_discounted.ids).to include(invoice_item3.id)
        expect(invoice3.invoice_items_discounted.ids).to include(invoice_item3a.id)
      end
    end

    describe '#revenue_discount' do
      it 'returns the revenue for the discounted items' do
        expect(invoice1.revenue_discount).to eq(80)
        expect(invoice3.revenue_discount).to eq(180)
      end
    end

    describe '#total_discounted_revenue' do
      it 'returns the total discounted_revenue' do
        expect(invoice1.total_discounted_revenue).to eq(420)
        expect(invoice3.total_discounted_revenue).to eq(530)
      end
    end

    describe '#customer_full_name' do
      it 'returns the full name of the customer' do
        expected = "#{customer1.first_name} #{customer1.last_name}"
        expect(invoice1.customer_full_name).to eq(expected)
      end
    end

    describe '#customer_address' do
      it 'returns the address of the customer' do
        expected = customer1.address
        expect(invoice1.customer_address).to eq(expected)
      end
    end

    describe '#city_state_zip' do
      it 'returns the city, state, and zip code of the customer' do
        expected = "#{customer1.city}, #{customer1.state} #{customer1.zip}"
        expect(invoice1.customer_city_state_zip).to eq(expected)
      end
    end
  end
end
