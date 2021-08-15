require 'rails_helper'

RSpec.describe 'merchant dashboard index (/merchant/:merchant_id/dashboard)' do
  include ActionView::Helpers::NumberHelper

  # See /spec/object_creation_helper.rb for more info on factories created
  create_objects_merchant_dashboard

  let(:top_five_customers) { merchant1.top_customers }
  let(:invoice_items_ready_to_ship) { merchant1.invoice_items_ready_to_ship }

  describe 'as a merchant' do
    describe 'when I visit my merchant dashboard' do
      before { visit merchant_dashboard_index_path(merchant1) }

      it { expect(page).to have_no_content('Success!') }
      it { expect(page).to have_no_content('Error!') }

      it 'displays the name of my merchant' do
        expect(page).to have_content(merchant1.name)
      end

      it 'displays a link to my merchant items index (/merchants/merchant_id/items)' do
        expect(page).to have_link('Items')

        click_link 'Items'

        expect(current_path).to eq("/merchant/#{merchant1.id}/items")
      end

      it 'displays a link to my merchant invoices index (/merchants/merchant_id/invoices)' do
        expect(page).to have_link('Invoices')

        click_link 'Invoices'

        expect(current_path).to eq("/merchant/#{merchant1.id}/invoices")
      end

      it 'displays a link to view all my discounts' do
        expect(page).to have_link('Bulk Discounts')
      end

      describe 'when I click the View All My Discounts link' do
        before { click_link 'Bulk Discounts' }

        it 'takes me to my bulk discounts index page' do
          expect(current_path).to eq(merchant_bulk_discounts_path(merchant1))
        end

        it 'displays all my bulk discounts: percentage discount and quantity thresholds' do
          within '#bulk-discounts' do
            merchant1.bulk_discounts.each do |bulk_discount|
              expect(page).to have_content("Bulk Discount # #{bulk_discount.id}")
              expect(page).to have_content("#{bulk_discount.percentage_discount}% off")
              expect(page).to have_content("#{bulk_discount.quantity_threshold} item(s)")
            end

            merchant2.bulk_discounts.each do |bulk_discount|
              expect(page).to have_no_content("Bulk Discount # #{bulk_discount.id}")
              expect(page).to have_no_content("#{bulk_discount.percentage_discount}% off")
              expect(page).to have_no_content("#{bulk_discount.quantity_threshold} item(s)")
            end
          end
        end
      end

      describe 'within the top five customers section' do
        it 'displays the names of the top 5 customers by number of transactions' do
          within '#top-five-customers' do
            top_five_customers.each do |customer|
              expect(page).to have_content("#{customer.first_name} #{customer.last_name}")
            end
          end
        end

        it 'displays the customer details next to each customer' do
          top_five_customers.each do |customer|
            within "#top-customer-#{customer.id}" do
              expect(page).to have_content(customer.full_name)
              expect(page).to have_content(customer.transaction_count)
              expect(page).to have_content(customer.total_items)
              expect(page).to have_content(number_to_currency(customer.total_revenue / 100.00))
            end
          end
        end
      end

      describe 'within the Items Ready to Ship section' do
        it 'displays list of the unshipped item names, the associated invoice id, and invoice creation date' do
          within '#ready-to-ship' do
            invoice_items_ready_to_ship.each do |invoice_item|
              expect(page).to have_content(invoice_item.item_name)
              expect(page).to have_content(invoice_item.invoice_id)
              expect(page).to have_content(invoice_item.invoice_created_at.strftime('%A, %B %-d, %Y'))
            end
          end
        end

        it 'displays a link to the item show page' do
          invoice_items_ready_to_ship.each do |invoice_item|
            visit merchant_dashboard_index_path(merchant1)

            within "#ship-item-#{invoice_item.id}" do
              expect(page).to have_link(invoice_item.item_name)

              click_link invoice_item.item_name

              expect(current_path).to eq(merchant_item_path(merchant1, invoice_item.item_id))
            end
          end
        end

        it 'displays a link to the invoice show page' do
          invoice_items_ready_to_ship.each do |invoice_item|
            visit merchant_dashboard_index_path(merchant1)

            within "#ship-item-#{invoice_item.id}" do
              expect(page).to have_link(invoice_item.invoice_id.to_s)

              click_link invoice_item.invoice_id.to_s

              expect(current_path).to eq(merchant_invoice_path(merchant1, invoice_item.invoice_id))
            end
          end
        end
      end
    end
  end
end
