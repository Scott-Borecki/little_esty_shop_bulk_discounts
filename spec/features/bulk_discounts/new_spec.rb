require 'rails_helper'

RSpec.describe 'bulk discounts new page (/merchant/:merchant_id/bulk_discounts/new)' do
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

  let(:percentage_discount) { 80 }
  let(:quantity_threshold) { 100 }

  describe 'as a merchant' do
    describe 'when I visit my merchant dashboard bulk discounts new (/merchant/:merchant_id/bulk_discounts/new)' do
      before { visit new_merchant_bulk_discount_path(merchant1) }

      it { expect(page).to have_no_content('Success!') }
      it { expect(page).to have_no_content('Error!') }

      it 'displays a form to create a new discount' do
        expect(current_path).to eq(new_merchant_bulk_discount_path(merchant1))
        expect(page).to have_field(:bulk_discount_percentage_discount)
        expect(page).to have_field(:bulk_discount_quantity_threshold)
        expect(page).to have_button('Create')
      end

      describe 'when I fill in the form with valid data' do
        before do
          fill_in :bulk_discount_percentage_discount, with: percentage_discount
          fill_in :bulk_discount_quantity_threshold, with: quantity_threshold
          click_button 'Create'
        end

        it 'takes me back tot he bulk discount index' do
          expect(current_path).to eq(merchant_bulk_discounts_path(merchant1))
        end

        it 'displays a flash success message' do
          expect(page).to have_content('Success! A new bulk discount was created.')
        end

        it 'displays my new bulk discount' do
          expect(BulkDiscount.last.percentage_discount).to eq(percentage_discount)
          expect(BulkDiscount.last.quantity_threshold).to eq(quantity_threshold)

          within "#bd-#{BulkDiscount.last.id}" do
            expect(page).to have_content(BulkDiscount.last.id)
            expect(page).to have_content(number_to_percentage(percentage_discount, precision: 0))
            expect(page).to have_content(quantity_threshold)
          end
        end
      end

      describe 'when I fill in the form with ininvalid input' do
        before do
          fill_in :bulk_discount_percentage_discount, with: 'hello'
          fill_in :bulk_discount_quantity_threshold, with: 'whats up'
          click_button 'Create'
        end

        it 'returns me to the bulk discounts new page' do
          expect(current_path).to eq(new_merchant_bulk_discount_path(merchant1))
        end

        it 'displays a flash error message' do
          expect(page).to have_content('Error! Percentage discount is not a number, Quantity threshold is not a number.')
        end

        it 'displays a form to create a new discount' do
          expect(current_path).to eq(new_merchant_bulk_discount_path(merchant1))
          expect(page).to have_field(:bulk_discount_percentage_discount)
          expect(page).to have_field(:bulk_discount_quantity_threshold)
          expect(page).to have_button('Create')
        end
      end
    end
  end
end
