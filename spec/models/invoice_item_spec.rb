require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end

  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe 'instance methods' do
    describe '#revenue' do
      it 'returns the revenue' do
        invoice_item = create(:invoice_item, :shipped, quantity: 4, unit_price: 10)

        expect(invoice_item.revenue).to eq(40)
      end
    end
  end
end
