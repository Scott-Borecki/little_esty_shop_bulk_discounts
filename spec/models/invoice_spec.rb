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
  end
end
