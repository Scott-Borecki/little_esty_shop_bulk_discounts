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
    describe '.top_revenue_day' do
      # See /spec/object_creation_helper.rb for more info on factories created
      create_objects_top_revenue_day

      it 'returns the date of the invoice with the most revenue' do
        expect(Invoice.top_revenue_day).to eq(invoice2.formatted_date)
      end
    end

    describe '.incomplete_invoices' do
      # See /spec/object_creation_helper.rb for more info on factories created
      create_objects

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
    create_objects

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
