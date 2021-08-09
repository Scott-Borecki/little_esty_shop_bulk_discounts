require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe "validations" do
    it { should validate_presence_of(:percentage_discount) }
    it { should validate_numericality_of(:percentage_discount) }
    it { should validate_presence_of(:quantity_threshold) }
    it { should validate_numericality_of(:quantity_threshold) }
  end

  describe "relationships" do
    it { should belong_to(:merchant) }
  end

  describe 'class methods' do
    describe '.max_discount' do
      it 'returns the max discount' do
        merchant       = create(:merchant)
        bulk_discount1 = create(:bulk_discount, quantity_threshold: 10, percentage_discount: 30, merchant: merchant)
        bulk_discount2 = create(:bulk_discount, quantity_threshold: 7,  percentage_discount: 5,  merchant: merchant)
        bulk_discount3 = create(:bulk_discount, quantity_threshold: 5,  percentage_discount: 25, merchant: merchant)
        bulk_discount4 = create(:bulk_discount, quantity_threshold: 2,  percentage_discount: 15, merchant: merchant)

        expect(BulkDiscount.max_discount(1)).to eq(nil)
        expect(BulkDiscount.max_discount(3)).to eq(bulk_discount4)
        expect(BulkDiscount.max_discount(5)).to eq(bulk_discount3)
        expect(BulkDiscount.max_discount(8)).to eq(bulk_discount3)
        expect(BulkDiscount.max_discount(10)).to eq(bulk_discount1)
      end
    end
  end
end
