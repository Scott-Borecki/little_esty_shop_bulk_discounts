require 'rails_helper'

describe 'admin merchant index (/admin/merchants)' do
  include ActionView::Helpers::NumberHelper

  # See /spec/object_creation_helper.rb for more info on factories created
  create_objects

  let(:all_merchants) {      Merchant.all }
  let(:enabled_merchants) {  Merchant.all.where(status: :enabled) }
  let(:disabled_merchants) { Merchant.all.where(status: :disabled) }
  let(:top_five_merchants) { Merchant.top_merchants_by_revenue }

  describe 'as an admin' do
    describe 'when I visit the admin merchants index' do
      before { visit admin_merchants_path }

      it { expect(current_path).to eq(admin_merchants_path) }
      it { expect(page).to have_no_content('Success!') }
      it { expect(page).to have_no_content('Error!') }

      it 'displays the name of each merchant with a link' do
        all_merchants.all.each do |merchant|
          expect(page).to have_content(merchant.name)
          expect(page).to have_link(merchant.name)
        end
      end

      it 'displays a link to create a new merchant' do
        expect(page).to have_link('Create New Merchant')
      end

      it 'displays an Enabled Merchants section with all the enabled merchants' do
        within('#enabled-merchants') do
          expect(page).to have_content('Enabled Merchants')
          expect(page).to have_no_content('Disabled Merchants')

          enabled_merchants.each do |merchant|
            expect(page).to have_content(merchant.name)
          end

          disabled_merchants.each do |merchant|
            expect(page).to have_no_content(merchant.name)
          end
        end
      end

      it 'displays an Disabled Merchants section with all the disabled merchants' do
        within('#disabled-merchants') do
          expect(page).to have_content('Disabled Merchants')
          expect(page).to have_no_content('Enabled Merchants')

          disabled_merchants.each do |merchant|
            expect(page).to have_content(merchant.name)
          end

          enabled_merchants.each do |merchant|
            expect(page).to have_no_content(merchant.name)
          end
        end
      end

      it 'displays a button next to each merchant name to disable or enable that merchant' do
        enabled_merchants.each do |merchant|
          within("#merchant-#{merchant.id}") do
            expect(page).to have_button('Disable')
            expect(page).to have_no_button('Enable')
          end
        end

        disabled_merchants.each do |merchant|
          within("#merchant-#{merchant.id}") do
            expect(page).to have_button('Enable')
            expect(page).to have_no_button('Disable')
          end
        end
      end

      context 'within the top 5 merchants section' do
        it 'displays the names of the top 5 merchants by total revenue generated' do
          within('#top-five-merchants') do
            top_five_merchants.each do |merchant|
              expect(page).to have_content(merchant.name)
            end

            expect(top_five_merchants[0].name).to appear_before(top_five_merchants[1].name)
            expect(top_five_merchants[1].name).to appear_before(top_five_merchants[2].name)
            expect(top_five_merchants[2].name).to appear_before(top_five_merchants[3].name)
            expect(top_five_merchants[3].name).to appear_before(top_five_merchants[4].name)
            expect(page).to have_no_content(merchant1.name)
          end
        end

        it 'links the names of the top 5 merchants to their admin merchant show page' do
          top_five_merchants.each do |merchant|
            within("#top-merchant-#{merchant.id}") do
              expect(page).to have_link(merchant.name)
              expect(page).to have_no_link(merchant1.name)
            end
          end
        end

        it 'displays the total revenue generated next to each top 5 merchants' do
          top_five_merchants.each do |merchant|
            within("#top-merchant-#{merchant.id}") do
              expect(page).to have_content(number_to_currency(merchant.revenue / 100.00))
            end
          end
        end

        it 'displays the merchants best day' do
          top_five_merchants.each do |merchant|
            within("#top-day-#{merchant.id}") do
              expect(page).to have_content("Top selling date for #{merchant.name} was #{merchant.top_revenue_day}")
            end
          end
        end
      end

      describe 'when I click on the name of a merchant' do
        context 'within the enabled/disabled section' do
          it 'takes me to the merchants admin show page (/admin/merchants/merchant_id)' do
            all_merchants.each do |merchant|
              visit admin_merchants_path

              within("#merchant-#{merchant.id}") do
                click_link merchant.name
              end

              expect(current_path).to eq(admin_merchant_path(merchant))
            end
          end
        end

        context 'within the top 5 merchants section' do
          it 'takes me to the merchants admin show page (/admin/merchants/merchant_id)' do
            top_five_merchants.each do |merchant|
              visit admin_merchants_path

              within('#top-five-merchants') { click_link merchant.name }

              expect(current_path).to eq(admin_merchant_path(merchant))
            end
          end
        end
      end

      describe 'when I click on the enable button' do
        before do
          within("#merchant-#{merchant4.id}") { click_button 'Enable' }
        end

        it 'redirects me back to the admin merchants index' do
          expect(current_path).to eq(admin_merchants_path)
        end

        it 'changes the merchants status' do
          expect(merchant4.enabled?).to be false

          merchant4.reload

          expect(merchant4.enabled?).to be true

          within '#enabled-merchants' do
            expect(page).to have_content(merchant4.name)
          end
        end
      end

      describe 'when I click on the disable button' do
        before do
          within("#merchant-#{merchant1.id}") { click_button 'Disable' }
        end

        it 'redirects me back to the admin merchants index' do
          expect(current_path).to eq(admin_merchants_path)
        end

        it 'changes the merchants status' do
          expect(merchant1.enabled?).to be true

          merchant1.reload

          expect(merchant1.enabled?).to be false

          within '#disabled-merchants' do
            expect(page).to have_content(merchant1.name)
          end
        end
      end

      describe 'when I click on Create New Merchant' do
        before { click_link 'Create New Merchant' }

        it 'takes me to the new admin merchant page' do
          expect(current_path).to eq(new_admin_merchant_path)
        end
      end
    end
  end
end
