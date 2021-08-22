require 'rails_helper'

RSpec.describe 'bulk discount show page (/merchant/:merchant_id/bulk_discounts/:id)' do
  include ActionView::Helpers::NumberHelper

  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }

  let!(:bulk_discount1_1) { create(:bulk_discount, merchant: merchant1) }
  let!(:bulk_discount1_2) { create(:bulk_discount, merchant: merchant1) }
  let!(:bulk_discount1_3) { create(:bulk_discount, merchant: merchant1) }
  let!(:bulk_discount2_1) { create(:bulk_discount, merchant: merchant2, quantity_threshold: 97, percentage_discount: 97) }
  let!(:bulk_discount2_2) { create(:bulk_discount, merchant: merchant2, quantity_threshold: 98, percentage_discount: 98) }
  let!(:bulk_discount2_3) { create(:bulk_discount, merchant: merchant2, quantity_threshold: 99, percentage_discount: 99) }

  describe 'as a merchant' do
    context 'when I visit my merchant dashboard bulk discount show page' do
      before { visit merchant_bulk_discount_path(merchant1, bulk_discount1_1) }

      it { expect(page).to have_no_content('Success!') }
      it { expect(page).to have_no_content('Error!') }

      it 'displays the bulk discounts quantity threshold and percentage discount' do
        expect(page).to have_current_path(merchant_bulk_discount_path(merchant1, bulk_discount1_1))

        expect(page).to have_content("Percentage Discount: #{number_to_percentage(bulk_discount1_1.percentage_discount, precision: 0)}")
        expect(page).to have_content("Quantity Threshold: #{bulk_discount1_1.quantity_threshold} item(s)")

        other_bulk_discounts = BulkDiscount.all
        other_bulk_discounts.delete(bulk_discount1_1)

        other_bulk_discounts.each do |bulk_discount|
          expect(page).to have_no_content("Percentage Discount: #{number_to_percentage(bulk_discount.percentage_discount, precision: 0)}")
          expect(page).to have_no_content("Quantity Threshold: #{bulk_discount.quantity_threshold} item(s)")
        end
      end

      it 'displays a link to edit the bulk discount' do
        expect(page).to have_link('Edit Bulk Discount')
      end

      context 'when I click on the edit bulk discount link' do
        before { click_link('Edit Bulk Discount') }

        it 'takes me to a new page with a prepopulated form' do
          expect(page).to have_current_path(edit_merchant_bulk_discount_path(merchant1, bulk_discount1_1))
          expect(page).to have_field(:bulk_discount_percentage_discount, with: bulk_discount1_1.percentage_discount)
          expect(page).to have_field(:bulk_discount_quantity_threshold, with: bulk_discount1_1.quantity_threshold)
          expect(page).to have_button('Update')
        end
      end
    end
  end
end
