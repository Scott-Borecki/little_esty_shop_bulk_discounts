require 'rails_helper'

describe "merchant items edit (/merchant/:merchant_id/items/:id/edit)" do
  let!(:merchant1) { create(:merchant) }
  let!(:item1) {create(:item, merchant: merchant1) }
  let!(:item2) {create(:item, merchant: merchant1) }

  describe 'as a merchant' do
    describe 'when I visit the merchant items edit page' do
      before { visit edit_merchant_item_path(merchant1, item1) }

      it "displays a prepopulated form with the items attributes" do
        expect(find_field('Name').value).to eq(item1.name)
        expect(find_field('Description').value).to eq(item1.description)
        expect(find_field('Unit price').value).to eq(item1.unit_price.to_s)

        expect(find_field('Name').value).to_not eq(item2.name)
      end

      describe 'when I fill in the form' do
        before do
          @new_name        = 'Bar Shampoo'
          @new_description = 'Eco friendly shampoo'
          @new_unit_price  = 15

          fill_in 'Name', with: @new_name
          fill_in 'Description', with: @new_description
          fill_in 'Unit price', with: @new_unit_price

          click_button 'Submit'
        end

        it 'redirects me to that items show page' do
          expect(current_path).to eq(merchant_item_path(merchant1, item1))
        end

        it 'displays the updated info' do
          expect(page).to have_content(@new_name)
          expect(page).to have_content(@new_description)
          expect(page).to have_content(@new_unit_price)
          expect(page).to have_no_content('This washes your hair')
        end

        it 'displays a success flash message' do
          expect(page).to have_content('Success! The item was updated.')
        end
      end

      describe 'when I fill in the form with invalid data' do
        before do
          @new_description = 'Eco friendly shampoo'
          @new_unit_price  = 15

          fill_in 'Name', with: ''
          fill_in 'Description', with: @new_description
          fill_in 'Unit price', with: @new_unit_price

          click_button 'Submit'
        end

        it "returns me to the admin item edit page" do
          expect(current_path).to eq(edit_merchant_item_path(merchant1, item1))
        end

        it "displays a flash message a flash message if not all sections are filled in" do
          expect(page).to have_content('Error! All fields must be completed.')
        end
      end
    end
  end
end
