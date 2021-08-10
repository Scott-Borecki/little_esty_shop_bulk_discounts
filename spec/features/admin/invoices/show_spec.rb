require 'rails_helper'

describe 'admin invoice show page (/admin/invoices/:id)' do
  include ActionView::Helpers::NumberHelper

  let!(:customer1) { create(:customer) }
  let!(:customer2) { create(:customer) }

  let!(:invoice1) { create(:invoice, customer: customer1, status: 2) }
  let!(:invoice2) { create(:invoice, customer: customer2) }

  let!(:item1a) { create(:item) }
  let!(:item1b) { create(:item) }
  let!(:item2a) { create(:item) }
  let!(:item2b) { create(:item) }
  let!(:item2c) { create(:item) }

  let!(:invoice_item1a) { create(:invoice_item, item: item1a, invoice: invoice1) }
  let!(:invoice_item1b) { create(:invoice_item, item: item1b, invoice: invoice1) }
  let!(:invoice_item2a) { create(:invoice_item, item: item2a, invoice: invoice2) }
  let!(:invoice_item2b) { create(:invoice_item, item: item2b, invoice: invoice2) }
  let!(:invoice_item2c) { create(:invoice_item, item: item2c, invoice: invoice2) }

  let!(:bulk_discount1) { create(:bulk_discount, merchant: item1a.merchant, quantity_threshold: 5) }
  let!(:bulk_discount2) { create(:bulk_discount, merchant: item2a.merchant, quantity_threshold: 10) }

  describe 'as an admin' do
    describe 'when I visit an admin invoice show page (/admin/invoices/:id)' do
      before { visit admin_invoice_path(invoice1) }

      it 'displays the invoice detials: id, status, and created_at' do
        expect(current_path).to eq(admin_invoice_path(invoice1))

        expect(page).to have_content("Invoice ##{invoice1.id}")
        expect(page).to have_content("Created on: #{invoice1.formatted_date}")

        expect(page).to have_no_content("Invoice ##{invoice2.id}")
      end

      it 'displays the customer details: name and address' do
        expect(page).to have_content("#{customer1.first_name} #{customer1.last_name}")
        expect(page).to have_content(customer1.address)
        expect(page).to have_content("#{customer1.city}, #{customer1.state} #{customer1.zip}")

        expect(page).to have_no_content("#{customer2.first_name} #{customer2.last_name}")
      end

      it 'displays all the items on the invoice and the item details: name, quantity, price, and status' do
        within '#invoice-items' do
          invoice1.invoice_items.each do |invoice_item|
            expect(page).to have_content(invoice_item.item.name)
            expect(page).to have_content(invoice_item.quantity)
            expect(page).to have_content(number_to_currency(invoice_item.unit_price / 100.00))
            expect(page).to have_content(invoice_item.status.titleize)
          end

          expect(page).to have_no_content(item2a.name)
          expect(page).to have_no_content(item2b.name)
          expect(page).to have_no_content(item2c.name)
        end
      end

      it 'displays the total revenue' do
        expect(page).to have_content("Total Revenue: #{number_to_currency(invoice1.total_revenue / 100.00)}")

        expect(page).to have_no_content(number_to_currency(invoice2.total_revenue / 100.00))
      end

      it 'displays the total discounts' do
        expect(page).to have_content("Total Discounts: #{number_to_currency(invoice1.revenue_discount / 100.00)}")

        expect(page).to have_no_content(number_to_currency(invoice2.revenue_discount / 100.00))
      end

      it 'displays the total discounted revenue' do
        expect(page).to have_content("Total Discounted Revenue: #{number_to_currency(invoice1.total_discounted_revenue / 100.00)}")

        expect(page).to have_no_content(number_to_currency(invoice2.total_discounted_revenue / 100.00))
      end

      it 'has a status select field that updates the invoices status' do
        within "#status-update-#{invoice1.id}" do
          expect(invoice1.status).to eq('completed')
          expect(page).to have_select('invoice[status]', selected: 'Completed')
          expect(page).to have_button('Update')

          select 'Cancelled', from: :invoice_status
          click_button 'Update'

          expect(current_path).to eq(admin_invoice_path(invoice1))
          expect(page).to have_select('invoice[status]', selected: 'Cancelled')
          expect(invoice1.reload.status).to eq('cancelled')
        end
      end
    end
  end
end
