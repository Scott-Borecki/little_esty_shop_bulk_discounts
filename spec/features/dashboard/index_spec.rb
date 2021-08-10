require 'rails_helper'

RSpec.describe 'merchant dashboard index (/merchant/:merchant_id/dashboard)' do
  # See /spec/object_creation_helper.rb for more info on factories created
  create_factories_merchant_dashboard

  let(:top_five_customers) { merchant1.top_customers_by_transactions }
  let(:items_ready_to_ship) { merchant1.items_ready_to_ship }

  describe 'as a merchant' do
    describe 'when I visit my merchant dashboard' do
      before { visit merchant_dashboard_index_path(merchant1) }

      it 'displays the name of my merchant' do
        expect(page).to have_content(merchant1.name)
      end

      it 'displays a link to my merchant items index (/merchants/merchant_id/items)' do
        expect(page).to have_link("Items")

        click_link "Items"

        expect(current_path).to eq("/merchant/#{merchant1.id}/items")
      end

      it 'displays a link to my merchant invoices index (/merchants/merchant_id/invoices)' do
        expect(page).to have_link("Invoices")

        click_link "Invoices"

        expect(current_path).to eq("/merchant/#{merchant1.id}/invoices")
      end

      it 'displays a link to view all my discounts' do
        expect(page).to have_link('View All My Discounts')
      end

      describe 'when I click the View All My Discounts link' do
        before { click_link 'View All My Discounts' }

        it 'takes me to my bulk discounts index page' do
          allow(HolidayService).to receive(:holidays).and_return(holidays_parsed)
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

        it 'displays the number of transactions next to each customer' do
          top_five_customers_transactions =
            top_five_customers.map do |customer|
              [customer.id, customer.number_transactions]
            end

          top_five_customers_transactions.each do |customer_id, number_transactions|
            within "#top-customer-#{customer_id}" do
              expect(page).to have_content(number_transactions)
            end
          end
        end
      end

      describe 'within the Items Ready to Ship section' do
        it 'displays list of the unshipped item names, the associated invoice id, and invoice creation date' do
          within '#items_ready_to_ship' do
            items_ready_to_ship.each do |item|
              expect(page).to have_content(item.item_name)
              expect(page).to have_content(item.invoice_id)
              expect(page).to have_content(item.invoice_created_at.strftime('%A, %B %-d, %Y'))
            end
          end
        end

        it 'displays a link to the invoice show page' do
          items_ready_to_ship.each do |item|
            visit merchant_dashboard_index_path(merchant1)

            within "#ship-item-#{item.id}" do
              expect(page).to have_link(item.invoice_id.to_s)

              click_link item.invoice_id.to_s

              expect(current_path).to eq(merchant_invoice_path(merchant1, item.invoice_id))
            end
          end
        end
      end
    end
  end
end
