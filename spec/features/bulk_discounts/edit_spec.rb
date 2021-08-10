require 'rails_helper'

RSpec.describe 'bulk discount edit page (/merchant/:merchant_id/bulk_discounts/:id/edit)' do
  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }

  let!(:bulk_discount1_1) { create(:bulk_discount, merchant: merchant1) }
  let!(:bulk_discount1_2) { create(:bulk_discount, merchant: merchant1) }
  let!(:bulk_discount1_3) { create(:bulk_discount, merchant: merchant1) }
  let!(:bulk_discount2_1) { create(:bulk_discount, merchant: merchant2) }
  let!(:bulk_discount2_2) { create(:bulk_discount, merchant: merchant2) }
  let!(:bulk_discount2_3) { create(:bulk_discount, merchant: merchant2) }

  let!(:new_percentage) { 17 }
  let!(:new_threshold) { 13 }

  describe 'as a merchant' do
    describe 'when I visit my merchant dashboard bulk discount edit (/merchant/:merchant_id/bulk_discounts/:id/edit)' do
      before { visit edit_merchant_bulk_discount_path(merchant1, bulk_discount1_1) }

      it { expect(page).to have_no_content('Success!') }
      it { expect(page).to have_no_content('Error!') }

      it 'displays a prepopulated form' do
        expect(current_path).to eq(edit_merchant_bulk_discount_path(merchant1, bulk_discount1_1))
        expect(page).to have_field(:bulk_discount_percentage_discount, with: bulk_discount1_1.percentage_discount)
        expect(page).to have_field(:bulk_discount_quantity_threshold, with: bulk_discount1_1.quantity_threshold)
        expect(page).to have_button('Update')
      end

      describe 'when I fill in the form with all new values' do
        before do
          fill_in 'bulk_discount_percentage_discount', with: new_percentage
          fill_in 'bulk_discount_quantity_threshold', with: new_threshold
          click_button 'Update'
        end

        it 'takes me to the bulk discounts show page' do
          expect(current_path).to eq(merchant_bulk_discount_path(merchant1, bulk_discount1_1))
        end

        it 'displays the updated bulk discount attributes' do
          bulk_discount1_1.reload

          expect(bulk_discount1_1.percentage_discount).to eq(new_percentage)
          expect(bulk_discount1_1.quantity_threshold).to eq(new_threshold)
          expect(page).to have_content("Percentage Discount: #{bulk_discount1_1.percentage_discount}%")
          expect(page).to have_content("Quantity Threshold: #{bulk_discount1_1.quantity_threshold} item(s)")
        end
      end

      describe 'when I fill in the form with one new value' do
        before do
          fill_in 'bulk_discount_percentage_discount', with: new_percentage
          click_button 'Update'
        end

        it 'takes me to the bulk discounts show page' do
          expect(current_path).to eq(merchant_bulk_discount_path(merchant1, bulk_discount1_1))
        end

        it 'displays a flash success message' do
          expect(page).to have_content('Success! The bulk discount was updated.')
        end

        it 'displays the updated bulk discount attributes' do
          quantity_threshold = bulk_discount1_1.quantity_threshold

          bulk_discount1_1.reload

          expect(bulk_discount1_1.percentage_discount).to eq(new_percentage)
          expect(bulk_discount1_1.quantity_threshold).to eq(quantity_threshold)
          expect(page).to have_content("Percentage Discount: #{bulk_discount1_1.percentage_discount}%")
          expect(page).to have_content("Quantity Threshold: #{bulk_discount1_1.quantity_threshold} item(s)")
        end

        it 'does not display other bulk discounts' do
          other_bulk_discounts = merchant1.bulk_discounts
          other_bulk_discounts.delete(bulk_discount1_1)

          other_bulk_discounts.each do |bulk_discount|
            expect(page).to have_no_content(bulk_discount.id)
          end

          merchant2.bulk_discounts.each do |bulk_discount|
            expect(page).to have_no_content(bulk_discount.id)
          end
        end
      end
    end
  end
end
