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

  describe 'as an admin' do
    describe 'when I visit an admin invoice show page (/admin/invoices/:id)' do
      before { visit admin_invoice_path(invoice1) }

      it 'displays the invoice detials: id, status, and created_at' do
        expect(current_path).to eq(admin_invoice_path(invoice1))

        expect(page).to have_content("Invoice ##{invoice1.id}")
        expect(page).to have_content("Created on:\n#{invoice1.formatted_date}")

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
            expect(page).to have_content(number_to_currency(invoice_item.unit_price))
            expect(page).to have_content(invoice_item.status)
          end

          expect(page).to have_no_content(item2a.name)
          expect(page).to have_no_content(item2b.name)
          expect(page).to have_no_content(item2c.name)
        end
      end

      it 'displays the total revenue' do
        expect(page).to have_content("Total Revenue:\n#{number_to_currency(invoice1.total_revenue)}")

        expect(page).to have_no_content(number_to_currency(invoice2.total_revenue))
      end

      it 'displays the total discounted revenue' do
        expect(page).to have_content("Total Discounted Revenue:\n#{number_to_currency(invoice1.total_discounted_revenue)}")

        expect(page).to have_no_content(number_to_currency(invoice2.total_discounted_revenue))
      end

      it 'has a status select field that updates the invoices status' do
        within "#status-update-#{invoice1.id}" do
          expect(invoice1.status).to eq('completed')
          expect(page).to have_select('invoice[status]', selected: 'completed')
          expect(page).to have_button('Update Invoice')

          select 'cancelled', from: :invoice_status
          click_button 'Update Invoice'

          expect(current_path).to eq(admin_invoice_path(invoice1))
          expect(page).to have_select('invoice[status]', selected: 'cancelled')
          expect(invoice1.reload.status).to eq('cancelled')
        end
      end
    end
  end
end
