require 'rails_helper'

describe 'merchant items edit (/merchant/:merchant_id/items/:id/edit)' do
  let!(:merchant1) { create(:merchant) }
  let!(:item1) { create(:item, merchant: merchant1, description: 'This washes your hair') }
  let!(:item2) { create(:item, merchant: merchant1) }

  let(:original_description) { 'This washes your hair' }

  let(:new_name) { 'Bar Shampoo' }
  let(:new_description) { 'Eco friendly shampoo' }
  let(:new_unit_price) { 15 }

  let(:flash_error) { 'Error! All fields must be completed.' }
  let(:flash_success) { 'Success! The item was updated.' }

  describe 'as a merchant' do
    context 'when I visit the merchant items edit page' do
      before { visit edit_merchant_item_path(merchant1, item1) }

      it { expect(page).to have_no_content('Success!') }
      it { expect(page).to have_no_content('Error!') }

      it 'displays a prepopulated form with the items attributes' do
        expect(page).to have_field(:item_name, with: item1.name)
        expect(page).to have_field(:item_description, with: item1.description)
        expect(page).to have_field(:item_unit_price, with: item1.unit_price)

        expect(page).to have_no_field(:item_name, with: item2.name)
      end

      context 'when I fill in the form' do
        before do
          fill_in :item_name, with: new_name
          fill_in :item_description, with: new_description
          fill_in :item_unit_price, with: new_unit_price

          click_button 'Submit'
        end

        it 'redirects me to that items show page' do
          expect(page).to have_current_path(merchant_item_path(merchant1, item1))
        end

        it 'displays the updated info' do
          expect(page).to have_content(new_name)
          expect(page).to have_content(new_description)
          expect(page).to have_content(new_unit_price)
          expect(page).to have_no_content(original_description)
        end

        it 'displays a success flash message' do
          expect(page).to have_content(flash_success)
        end
      end

      context 'when I fill in the form with invalid data' do
        before do
          fill_in :item_name, with: ''
          fill_in :item_description, with: new_description
          fill_in :item_unit_price, with: new_unit_price

          click_button 'Submit'
        end

        it 'returns me to the admin item edit page' do
          expect(page).to have_current_path(edit_merchant_item_path(merchant1, item1))
        end

        it 'displays a flash message a flash message if not all sections are filled in' do
          expect(page).to have_content(flash_error)
        end
      end
    end
  end
end
