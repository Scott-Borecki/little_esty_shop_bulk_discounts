require 'rails_helper'

RSpec.describe 'admin merchants new (/admin/merchants/new)' do
  describe 'as an admin' do
    describe 'when I visit the admin merchants new (/admin/merchants/new)' do
      before { visit new_admin_merchant_path }

      specify { expect(current_path).to eq(new_admin_merchant_path) }

      it 'displays a form that allows me to add merchant information' do
        expect(page).to have_field(:merchant_name)
        expect(page).to have_button('Submit')
      end

      describe 'when I fill out the form and click Submit' do
        before do
          fill_in :merchant_name, with: 'Foo Bar'
          click_button 'Submit'
        end

        it 'takes me back to the admin merchants index page' do
          expect(current_path).to eq(admin_merchants_path)
        end

        it 'displays the merchant that was just created' do
          within('#disabled-merchants') do
            expect(page).to have_content('Foo Bar')
          end
        end

        it 'displays a flash success message' do
          flash_message = 'Success! A new merchant was created.'
          expect(page).to have_content(flash_message)
        end
      end
    end
  end
end
