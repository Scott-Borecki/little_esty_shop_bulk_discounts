require 'rails_helper'

RSpec.describe 'bulk discounts index page (/merchant/:merchant_id/bulk_discounts)' do
  include ActionView::Helpers::NumberHelper

  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }

  let!(:bulk_discount1_1) { create(:bulk_discount, merchant: merchant1) }
  let!(:bulk_discount1_2) { create(:bulk_discount, merchant: merchant1) }
  let!(:bulk_discount1_3) { create(:bulk_discount, merchant: merchant1) }
  let!(:bulk_discount2_1) { create(:bulk_discount, merchant: merchant2) }
  let!(:bulk_discount2_2) { create(:bulk_discount, merchant: merchant2) }
  let!(:bulk_discount2_3) { create(:bulk_discount, merchant: merchant2) }

  let!(:item1) { create(:item, merchant: merchant1) }
  let!(:invoice1) { create(:invoice) }
  let!(:transaction1) { create(:transaction, result: 1, invoice: invoice1) }
  let!(:invoice_item1) { create(:invoice_item, invoice: invoice1, item: item1) }

  describe 'as a merchant' do
    describe 'when I visit my merchant dashboard bulk discounts index (/merchant/:merchant_id/bulk_discounts)' do
      before do
        visit merchant_bulk_discounts_path(merchant1)
      end

      it { expect(page).to have_no_content('Success!') }
      it { expect(page).to have_no_content('Error!') }

      it 'displays all my bulk discounts: percentage discount and quantity thresholds' do
        within '#bulk-discounts' do
          merchant1.bulk_discounts.each do |bulk_discount|
            within "#bd-#{bulk_discount.id}" do
              expect(page).to have_content(bulk_discount.id)
              expect(page).to have_content(number_to_percentage(bulk_discount.percentage_discount, precision: 0))
              expect(page).to have_content(bulk_discount.quantity_threshold)
              expect(page).to have_button('View')
              expect(page).to have_button('Edit')
              expect(page).to have_button('Delete')
            end
          end

          merchant2.bulk_discounts.each do |bulk_discount|
            expect(page).to have_no_css("#bd-#{bulk_discount.id}")
            expect(page).to have_no_content("Bulk Discount # #{bulk_discount.id}")
          end
        end
      end

      it 'has a link to each bulk discount show page' do
        merchant1.bulk_discounts.each do |bulk_discount|
          visit merchant_bulk_discounts_path(merchant1)

          within "#bd-#{bulk_discount.id}" do
            expect(page).to have_link(bulk_discount.id.to_s)

            click_link bulk_discount.id.to_s

            expect(page).to have_current_path(merchant_bulk_discount_path(merchant1, bulk_discount.id))
          end
        end
      end

      it 'has a link to create a new discount' do
        expect(page).to have_link('Create New Bulk Discount')

        click_link 'Create New Bulk Discount'

        expect(page).to have_current_path(new_merchant_bulk_discount_path(merchant1))
        expect(page).to have_field(:bulk_discount_percentage_discount)
        expect(page).to have_field(:bulk_discount_quantity_threshold)
        expect(page).to have_button('Create')
      end

      it 'has a link to view each bulk discount' do
        button_text = 'View'

        merchant1.bulk_discounts.each do |bulk_discount|
          visit merchant_bulk_discounts_path(merchant1)

          within "#bd-#{bulk_discount.id}" do
            expect(page).to have_button(button_text)

            click_button button_text
          end

          expect(page).to have_current_path(merchant_bulk_discount_path(merchant1, bulk_discount))
          expect(page).to have_no_css("#bd-#{bulk_discount.id}")
        end
      end

      it 'has a link to edit each bulk discount' do
        button_text = 'Edit'

        merchant1.bulk_discounts.each do |bulk_discount|
          visit merchant_bulk_discounts_path(merchant1)

          within "#bd-#{bulk_discount.id}" do
            expect(page).to have_button(button_text)

            click_button button_text
          end

          expect(page).to have_current_path(edit_merchant_bulk_discount_path(merchant1, bulk_discount))
          expect(page).to have_no_css("#bd-#{bulk_discount.id}")
        end
      end

      it 'has a link to delete each bulk discount' do
        button_text = 'Delete'

        merchant1.bulk_discounts.each do |bulk_discount|
          visit merchant_bulk_discounts_path(merchant1)

          within "#bd-#{bulk_discount.id}" do
            expect(page).to have_button(button_text)

            click_button button_text
          end

          expect(page).to have_current_path(merchant_bulk_discounts_path(merchant1))
          expect(page).to have_no_css("#bd-#{bulk_discount.id}")
        end
      end

      it 'displays a section with a header of Upcoming Holidays' do
        within '#upcoming-holidays' do
          expect(page).to have_content('Upcoming Holidays')
        end
      end

      it 'displays the name and date of the next three upcoming US holidays' do
        upcoming_holidays = HolidayFacade.upcoming_holidays

        within '#upcoming-holidays' do
          upcoming_holidays.each do |holiday|
            expect(page).to have_content(holiday.local_name)
            expect(page).to have_content(holiday.date)
          end
        end
      end

      describe 'within the Merchant Metrics section' do
        it 'displays the merchant metrics' do
          within '#merchant-metrics' do
            expect(page).to have_content("Total Revenue: #{number_to_currency(merchant1.invoice_items_total_revenue / 100.00)}")
            unless merchant1.invoice_items_revenue_discount == 0
              expect(page).to have_content("Discounts Applied: -#{number_to_currency(merchant1.invoice_items_revenue_discount / 100.00)}")
            end
            expect(page).to have_content("Total Discounted Revenue: #{number_to_currency(merchant1.invoice_items_total_discounted_revenue / 100.00)}")
            expect(page).to have_content("Total Items Sold: #{merchant1.total_items_sold}")
            expect(page).to have_content("Top Revenue Day: #{merchant1.top_revenue_day}")
          end
        end
      end
    end
  end
end
