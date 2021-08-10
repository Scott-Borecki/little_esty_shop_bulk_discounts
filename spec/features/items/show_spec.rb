require 'rails_helper'

describe 'merchant items show (/merchant/:merchant_id/items/:id)' do
  let!(:merchant) { create(:merchant) }

  let!(:item1) { create(:item, unit_price: 10, merchant: merchant) }
  let!(:item2) { create(:item, unit_price: 8,  merchant: merchant) }
  let!(:item3) { create(:item, unit_price: 5,  merchant: merchant) }
  let!(:item4) { create(:item, unit_price: 1,  merchant: merchant) }

  describe 'as a merchant' do
    describe 'when I visit the merchant item show page' do
      before { visit merchant_item_path(merchant, item1) }

      it { expect(page).to have_no_content('Success!') }
      it { expect(page).to have_no_content('Error!') }

      it 'displays the items attributes' do
        expect(page).to have_content(item1.name)
        expect(page).to have_content(item1.description)
        expect(page).to have_content(item1.unit_price / 100.00)
        expect(page).to have_no_content(item2.name)
      end

      it 'displays a link to update item info' do
        expect(page).to have_link('Update Item')

        click_link 'Update Item'

        expect(current_path).to eq(edit_merchant_item_path(merchant, item1))
      end
    end
  end
end
