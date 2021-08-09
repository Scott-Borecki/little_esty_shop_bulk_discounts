require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should define_enum_for(:status).with_values(pending: 0, packaged: 1, shipped: 2) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:status) }
  end

  describe "relationships" do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
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
