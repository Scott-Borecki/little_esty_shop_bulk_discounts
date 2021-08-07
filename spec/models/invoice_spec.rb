require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end

  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end

  describe 'instance methods' do
    # See spec/object_creation_helper.rb for objection creation details
    create_factories

    describe '#total_revenue' do
      it 'returns the total revenue' do
        expect(invoice1.total_revenue).to eq(500)
        expect(invoice3.total_revenue).to eq(650)
      end
    end

    describe '#discounted_items' do
      it 'returns the items qualifying for a bulk discount' do
        expect(invoice1.discounted_items.length).to eq(1)
        expect(invoice1.discounted_items.ids).to eq([invoice_item1b.id])
        expect(invoice1.discounted_items.first.total_revenue).to eq(400)
        expect(invoice1.discounted_items.first.max_discount).to eq(20)

        expect(invoice3.discounted_items.length).to eq(2)
        expect(invoice3.discounted_items.ids).to eq([invoice_item3a.id, invoice_item3b.id])
        expect(invoice3.discounted_items.first.total_revenue).to eq(150)
        expect(invoice3.discounted_items.first.max_discount).to eq(20)
      end
    end
  end
end
