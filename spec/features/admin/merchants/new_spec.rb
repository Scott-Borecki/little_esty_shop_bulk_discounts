require 'rails_helper'

RSpec.describe 'admin merchants new (/admin/merchants/new)' do
  describe 'as an admin' do
    context 'when I visit the admin merchants new page' do
      before { visit new_admin_merchant_path }

      it { expect(page).to have_current_path(new_admin_merchant_path) }
      it { expect(page).to have_no_content('Success!') }
      it { expect(page).to have_no_content('Error!') }

      it 'displays a form that allows me to add merchant information' do
        expect(page).to have_field(:merchant_name)
        expect(page).to have_button('Submit')
      end

      context 'when I fill out the form and click Submit' do
        before do
          fill_in :merchant_name, with: 'Foo Bar'
          click_button 'Submit'
        end

        it 'takes me back to the admin merchants index page' do
          expect(page).to have_current_path(admin_merchants_path)
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
