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

  describe 'instance methods' do
    # See spec/object_creation_helper.rb for objection creation details
    create_factories

    describe '#total_revenue' do
      it 'returns the total revenue' do
        expect(invoice1.total_revenue).to eq(500)
        expect(invoice3.total_revenue).to eq(710)
      end
    end

    describe '#discounted_invoice_items' do
      it 'returns the items qualifying for a bulk discount' do
        expect(invoice1.discounted_invoice_items.length).to eq(1)
        expect(invoice1.discounted_invoice_items.ids).to eq([invoice_item1b.id])

        expect(invoice3.discounted_invoice_items.length).to eq(2)
        expect(invoice3.discounted_invoice_items.ids).to eq([invoice_item3.id, invoice_item3a.id])
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
  end
end
