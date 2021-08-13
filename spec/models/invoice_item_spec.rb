require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'validations' do
    it { should define_enum_for(:status).with_values(pending: 0, packaged: 1, shipped: 2) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:status) }
  end

  describe 'relationships' do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
  end

  describe 'scopes' do
    let!(:merchant1) { create(:merchant) }
    let!(:merchant2) { create(:merchant) }

    let!(:item1) { create(:item, merchant: merchant1) }
    let!(:item2) { create(:item, merchant: merchant2) }

    let!(:invoice_item1) { create(:invoice_item, item: item1, quantity: 2,  unit_price: 10) }
    let!(:invoice_item2) { create(:invoice_item, item: item1, quantity: 4,  unit_price: 10) }
    let!(:invoice_item3) { create(:invoice_item, item: item1, quantity: 7,  unit_price: 10) }
    let!(:invoice_item4) { create(:invoice_item, item: item2, quantity: 10, unit_price: 10) }
    let!(:invoice_item5) { create(:invoice_item, item: item2, quantity: 0,  unit_price: 10) }
    let!(:invoice_item6) { create(:invoice_item, item: item2, quantity: 7,  unit_price: 10) }

    let!(:bulk_discount1) { create(:bulk_discount, merchant: merchant1, quantity_threshold: 3, percentage_discount: 10) }
    let!(:bulk_discount2) { create(:bulk_discount, merchant: merchant2, quantity_threshold: 8, percentage_discount: 20) }

    describe '.discounted' do
      it 'returns the invoice items that qualify for discounts' do
        discounted_invoice_items = [invoice_item2, invoice_item3, invoice_item4]

        expect(InvoiceItem.discounted.length).to eq(discounted_invoice_items.length)

        discounted_invoice_items.each do |invoice_item|
          expect(InvoiceItem.discounted).to include(invoice_item)
        end
      end
    end

    describe '.revenue_discount' do
      it 'returns the revenue discount of the invoice items' do
        expect(InvoiceItem.revenue_discount).to eq(31)
      end
    end

    describe '.total_discounted_revenue' do
      it 'returns the total revenue less the discount of the invoice items' do
        expect(InvoiceItem.total_discounted_revenue).to eq(269)
      end
    end

    describe '.total_revenue' do
      it 'returns the total revenue of the invoice items' do
        expect(InvoiceItem.total_revenue).to eq(300)
      end
    end
  end

  describe 'class methods' do
    describe '.items_ready_to_ship' do
      # See /spec/object_creation_helper.rb for more info on factories created
      create_objects_merchant_with_many_customers_and_items

      let(:invoice_items_to_ship) do
        [invoice_item3d_1, invoice_item6a_2, invoice_item4c_1, invoice_item10a_1,
         invoice_item3e_1, invoice_item4b_2, invoice_item3b_1, invoice_item3b_2,
         invoice_item7b_1, invoice_item7a_2, invoice_item1a_1, invoice_item1a_2,
         invoice_item8a_1, invoice_item8a_2]
      end

      it 'returns the invoice and item ids for each item ready to ship' do
        expect(InvoiceItem.items_ready_to_ship.map(&:invoice_id)).to eq(invoice_items_to_ship.map(&:invoice_id))
        expect(InvoiceItem.items_ready_to_ship.map(&:item_id)).to eq(invoice_items_to_ship.map(&:item_id))
      end

      it 'returns the item name for each item ready to ship' do
        item_names =
          invoice_items_to_ship.map do |invoice_item|
            Item.find(invoice_item.item_id).name
          end

        expect(InvoiceItem.items_ready_to_ship.map(&:item_name)).to eq(item_names)
      end

      it 'returns the invoice creation date for each item ready to ship ordered by creation date' do
        invoice_created_at =
          invoice_items_to_ship.map do |invoice_item|
            Invoice.find(invoice_item.invoice_id).created_at
          end

        expect(InvoiceItem.items_ready_to_ship.map(&:invoice_created_at)).to eq(invoice_created_at)
      end
    end
  end

  describe 'instance methods' do
    describe '#revenue' do
      it 'returns the revenue' do
        invoice_item = create(:invoice_item, :shipped, quantity: 4, unit_price: 10)

        expect(invoice_item.revenue).to eq(40)
      end
    end

    describe '#max_discount instance methods' do
      let!(:merchant) { create(:merchant) }

      let!(:item) { create(:item, merchant: merchant) }

      let!(:bulk_discount1) { create(:bulk_discount, quantity_threshold: 10, percentage_discount: 10, merchant: merchant) }
      let!(:bulk_discount2) { create(:bulk_discount, quantity_threshold: 3,  percentage_discount: 5,  merchant: merchant) }
      let!(:bulk_discount3) { create(:bulk_discount, quantity_threshold: 1,  percentage_discount: 25, merchant: merchant) }
      let!(:bulk_discount4) { create(:bulk_discount, quantity_threshold: 2,  percentage_discount: 15, merchant: merchant) }

      let!(:invoice_item) { create(:invoice_item, :shipped, quantity: 4, unit_price: 10, item: item) }

      describe '#max_discount' do
        it 'returns the max discount object' do
          expect(invoice_item.max_discount).to eq(bulk_discount3)
        end
      end

      describe '#max_discount_percentage' do
        it 'returns the max discount object' do
          expect(invoice_item.max_discount_percentage).to eq(bulk_discount3.percentage_discount)
        end
      end

      describe '#max_discount_id' do
        it 'returns the max discount object' do
          expect(invoice_item.max_discount_id).to eq(bulk_discount3.id)
        end
      end
    end
  end
end
