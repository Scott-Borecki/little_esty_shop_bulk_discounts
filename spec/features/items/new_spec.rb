require 'rails_helper'

RSpec.describe 'merchant items new (/merchant/:merchant_id/items/new)' do
  let(:merchant1) { create(:merchant) }
  let(:merchant2) { create(:merchant) }

  describe 'as an admin' do
    context 'when I visit the merchant items new page' do
      before { visit new_merchant_item_path(merchant1) }

      it { expect(page).to have_current_path(new_merchant_item_path(merchant1)) }
      it { expect(page).to have_no_content('Success!') }
      it { expect(page).to have_no_content('Error!') }

      it 'displays a form that allows me to add item information' do
        expect(page).to have_field(:item_name)
        expect(page).to have_field(:item_description)
        expect(page).to have_field(:item_unit_price)
        expect(page).to have_button('Submit')
      end

      context 'when I fill out the form and click Submit' do
        before do
          fill_in :item_name, with: 'Foo Bar'
          fill_in :item_description, with: 'It is a different type of soap!'
          fill_in :item_unit_price, with: 1499
          click_button 'Submit'
        end

        it 'takes me back to the merchant items index page' do
          expect(page).to have_current_path(merchant_items_path(merchant1))
        end

        it 'displays the item that was just created' do
          within('#disabled-items') do
            expect(page).to have_content('Foo Bar')
          end
        end

        it 'displays a flash success message' do
          flash_message = 'Success! A new item was created.'
          expect(page).to have_content(flash_message)
        end
      end
    end
  end
end
