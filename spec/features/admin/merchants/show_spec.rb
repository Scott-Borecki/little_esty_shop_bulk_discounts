require 'rails_helper'

RSpec.describe 'admin merchants show (/admin/merchants/merchant_id)' do
  let!(:merchant1) { create(:enabled_merchant) }
  let!(:merchant2) { create(:enabled_merchant) }
  let!(:merchant3) { create(:enabled_merchant) }

  describe 'as an admin' do
    describe 'when I visit the admin merchants show page' do
      before { visit admin_merchant_path(merchant1) }

      it { expect(current_path).to eq(admin_merchant_path(merchant1)) }
      it { expect(page).to have_no_content('Update successful!') }
      it { expect(page).to have_no_content('Error! All fields must be completed.') }

      it 'displays the name of the merchant' do
        expect(page).to have_content(merchant1.name)
        expect(page).to have_no_content(merchant2.name)
        expect(page).to have_no_content(merchant3.name)
      end

      it 'has a link to update the merchants information' do
        expect(page).to have_link('Update Merchant')
      end

      describe 'when I click the update link' do
        before { click_link 'Update Merchant' }

        it 'takes me to a page to edit the merchant' do
          expect(current_path).to eq(edit_admin_merchant_path(merchant1))
        end
      end
    end
  end
end
