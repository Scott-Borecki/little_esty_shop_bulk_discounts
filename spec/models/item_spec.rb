require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should define_enum_for(:status).with_values(disabled: 0, enabled: 1) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price) }
  end

  describe 'relationships' do
    it { should have_many(:invoices).through(:invoice_items) }
    it { should belong_to(:merchant) }
  end

  describe 'instance methods' do
    describe '#best_day' do
      # See /spec/object_creation_helper.rb for more info on factories created
      create_objects_best_day

      it 'returns the best day by revenue and most recent' do
        expect(item1.best_day).to eq(invoice2.formatted_date)
      end
    end
  end
end
