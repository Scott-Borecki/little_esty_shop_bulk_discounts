require 'rails_helper'

RSpec.describe 'merchant invoices show (/merchants/:merchant_id/invoices/:invoice_id)' do
  # See spec/object_creation_helper.rb for objection creation details
  create_factories

  describe 'as a merchant' do
    describe 'when I visit my merchant invoices show page' do
      before { visit merchant_invoice_path(merchant3, invoice3) }

      it 'displays the invoice id' do
        other_invoices = Invoice.all.to_a
        other_invoices.delete(invoice3)
        expect(other_invoices).to_not include(invoice3)

        within '#invoice-id' do
          expect(page).to have_content(invoice3.id)

          other_invoices.each do |invoice|
            expect(page).to have_no_content(invoice.id)
          end
        end
      end

      it 'displays the invoice and customer details' do
        other_invoices = Invoice.all.to_a
        other_invoices.delete(invoice3)
        expect(other_invoices).to_not include(invoice3)

        within '#invoice-details' do
          expect(page).to have_content("#{invoice3.customer.first_name} #{invoice3.customer.last_name}")
          expect(page).to have_content(invoice3.formatted_date)

          other_invoices.each do |invoice|
            expect(page).to have_no_content("#{invoice.customer.first_name} #{invoice.customer.last_name}")
          end
        end

        within('#invoice-status') { expect(page).to have_content(invoice3.status.humanize) }
      end

      it 'displays the total revenue for this invoice' do
        expect(page).to have_content("Total Revenue: $#{invoice3.total_revenue}")
      end

      it 'displays the total discounted revenue for this invoice' do
        expect(page).to have_content("Total Discounted Revenue: $#{invoice3.total_discounted_revenue}")
      end

      it 'displays the details of the invoice items' do
        invoice3.invoice_items.each do |invoice_item|
          within "#ii-#{invoice_item.id}" do
            expect(page).to have_content(invoice_item.item.name)
            expect(page).to have_content(invoice_item.quantity)
            expect(page).to have_content(invoice_item.unit_price)
          end
        end
      end

      it 'displays a select field to update the invoice status' do
        within '#invoice-status' do
          expect(page).to have_content('Completed')

          expect(page).to have_no_content('In progress')
          expect(page).to have_no_content('in progress')
          expect(page).to have_no_content('Cancelled')
          expect(page).to have_no_content('cancelled')
        end

        within "#ii-#{invoice_item3a.id}" do
          page.select 'cancelled'
          click_button 'Update Invoice'
        end

        within '#invoice-status' do
          expect(page).to have_content('Cancelled')

          expect(page).to have_no_content('In progress')
          expect(page).to have_no_content('in progress')
          expect(page).to have_no_content('Completed')
          expect(page).to have_no_content('completed')
        end
      end

      it 'displays a link to the bulk discount applied to each item' do
        within "#ii-#{invoice_item3.id}" do
          expect(page).to have_link("#{invoice_item3.max_discount_percentage}%")
          click_link "#{invoice_item3.max_discount_percentage}%"
          expect(current_path).to eq(merchant_bulk_discount_path(merchant3, invoice_item3.max_discount_id))
        end

        visit merchant_invoice_path(merchant3, invoice3)
        within "#ii-#{invoice_item3a.id}" do
          expect(page).to have_link("#{invoice_item3a.max_discount_percentage}%")

          click_link "#{invoice_item3a.max_discount_percentage}%"

          expect(current_path).to eq(merchant_bulk_discount_path(merchant3, invoice_item3a.max_discount_id))        
        end

        visit merchant_invoice_path(merchant3, invoice3)
        within "#ii-#{invoice_item3b.id}" do
          expect(page).to have_no_link("#{bulk_discount3a.percentage_discount}%")
          expect(page).to have_no_link("#{bulk_discount3b.percentage_discount}%")
          expect(page).to have_no_link("#{bulk_discount3c.percentage_discount}%")
        end
      end
    end
  end
end
