require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should define_enum_for(:status).with_values(cancelled: 0, 'in progress': 1, completed: 2) }
    it { should validate_presence_of(:status) }

    it 'is valid with valid attributes' do
      invoice = create(:invoice)
      expect(invoice).to be_valid
    end
  end

  describe 'delegations' do
    it { should delegate_method(:full_name).to(:customer).with_prefix }
    it { should delegate_method(:address).to(:customer).with_prefix }
    it { should delegate_method(:city_state_zip).to(:customer).with_prefix }
    it { should delegate_method(:revenue_discount).to(:invoice_items) }
    it { should delegate_method(:total_discounted_revenue).to(:invoice_items) }
    it { should delegate_method(:total_revenue).to(:invoice_items) }
    it { should delegate_method(:discounted).to(:invoice_items).with_prefix }
  end

  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:transactions) }
  end

  describe 'class methods' do
    describe '.top_revenue_day' do
      # See /spec/sample_data/create_objects_top_revenue_day.rb for more info on factories created
      create_objects_top_revenue_day

      it 'returns the date of the invoice with the most revenue' do
        expect(Invoice.top_revenue_day).to eq(invoice2.formatted_date)
      end
    end

    describe '.incomplete_invoices' do
      # See /spec/sample_data/create_objects.rb for more info on factories created
      create_objects

      let(:invoices_not_shipped) { [invoice5a, invoice5b, invoice3, invoice1] }

      it 'returns all the incomplete invoices (i.e. not shipped) ordered by oldest to newest' do
        expect(Invoice.incomplete_invoices).to eq(invoices_not_shipped)
      end

      it 'returns all the ids of the incomplete invoices (i.e. not shipped)' do
        expect(Invoice.incomplete_invoices.map(&:id)).to eq(invoices_not_shipped.map(&:id))
      end

      it 'returns all the invoice dates of the incomplete invoices (i.e. not shipped)' do
        expect(Invoice.incomplete_invoices.map(&:formatted_date)).to eq(invoices_not_shipped.map(&:formatted_date))
      end
    end
  end
end
