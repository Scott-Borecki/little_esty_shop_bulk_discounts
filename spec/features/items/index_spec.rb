require 'rails_helper'

describe 'merchant items index (merchants/merchant_id/items)' do
  include ActionView::Helpers::NumberHelper

  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }

  let!(:item1) {create(:item, merchant: merchant1, status: 1) }
  let!(:item2) {create(:item, merchant: merchant1) }
  let!(:item3) {create(:item, merchant: merchant1) }
  let!(:item4) {create(:item, merchant: merchant1) }
  let!(:item7) {create(:item, merchant: merchant1) }
  let!(:item8) {create(:item, merchant: merchant1) }

  let!(:item5) {create(:item, merchant: merchant2) }
  let!(:item6) {create(:item, merchant: merchant2) }

  let!(:invoice1) { create(:invoice, status: 2, created_at: '2012-03-27 14:54:09') }
  let!(:invoice2) { create(:invoice, status: 2, created_at: '2012-03-28 14:54:09') }
  let!(:invoice3) { create(:invoice, status: 2) }
  let!(:invoice4) { create(:invoice, status: 2) }
  let!(:invoice5) { create(:invoice, status: 2) }
  let!(:invoice6) { create(:invoice, status: 2) }
  let!(:invoice7) { create(:invoice, status: 2) }

  let!(:ii1) { create(:invoice_item, invoice: invoice1, item: item1, quantity: 9, unit_price: 10099, status: 0) }
  let!(:ii2) { create(:invoice_item, invoice: invoice2, item: item1, quantity: 1, unit_price: 10099, status: 0) }
  let!(:ii3) { create(:invoice_item, invoice: invoice3, item: item2, quantity: 2, unit_price: 8099,  status: 2) }
  let!(:ii4) { create(:invoice_item, invoice: invoice4, item: item3, quantity: 3, unit_price: 5099,  status: 1) }
  let!(:ii6) { create(:invoice_item, invoice: invoice5, item: item4, quantity: 1, unit_price: 1099,  status: 1) }
  let!(:ii7) { create(:invoice_item, invoice: invoice6, item: item7, quantity: 1, unit_price: 3099,  status: 1) }
  let!(:ii8) { create(:invoice_item, invoice: invoice7, item: item8, quantity: 1, unit_price: 5099,  status: 1) }
  let!(:ii9) { create(:invoice_item, invoice: invoice7, item: item4, quantity: 1, unit_price: 1099,  status: 1) }

  let!(:transaction1) { create(:transaction, result: 1, invoice: invoice1) }
  let!(:transaction2) { create(:transaction, result: 1, invoice: invoice2) }
  let!(:transaction3) { create(:transaction, result: 1, invoice: invoice3) }
  let!(:transaction4) { create(:transaction, result: 1, invoice: invoice4) }
  let!(:transaction5) { create(:transaction, result: 1, invoice: invoice5) }
  let!(:transaction6) { create(:transaction, result: 0, invoice: invoice6) }
  let!(:transaction7) { create(:transaction, result: 1, invoice: invoice7) }

  let(:merchant1_enabled_items) { merchant1.items.where(status: :enabled) }
  let(:merchant1_disabled_items) { merchant1.items.where(status: :disabled) }
  let(:merchant1_top_items) { merchant1.top_items_by_revenue }


  describe 'as a merchant' do
    describe 'when I visit my merchant items index page' do
      before { visit merchant_items_path(merchant1) }

      it { expect(current_path).to eq(merchant_items_path(merchant1)) }
      it { expect(page).to have_no_content('Success! The item was created.') }
      it { expect(page).to have_no_content('Success! The item was updated.') }
      it { expect(page).to have_no_content('Error! All fields must be completed.') }

      it 'displays a list of the names of all my items' do
        merchant1.items.each do |item|
          expect(page).to have_content(item.name)
        end

        merchant2.items.each do |item|
          expect(page).to have_no_content(item.name)
        end
      end

      it 'links each items name to its show page' do
        merchant1.items.each do |item|
          expect(page).to have_link(item.name)
        end

        within "#item-#{item1.id}" do
          click_link item1.name
        end

        expect(current_path).to eq(merchant_item_path(merchant1, item1))
      end

      it 'displays a link to create a new item' do
        expect(page).to have_link('Create New Item')

        click_link 'Create New Item'

        expect(current_path).to eq(new_merchant_item_path(merchant1))
      end

      it 'displays an Enabled Items section with all the enabled items' do
        within('#enabled-items') do
          expect(page).to have_content('Enabled Items')
          expect(page).to have_no_content('Disabled Items')

          merchant1_enabled_items.each do |item|
            expect(page).to have_content(item.name)
          end

          merchant1_disabled_items.each do |item|
            expect(page).to have_no_content(item.name)
          end
        end
      end

      it 'displays an Disabled Items section with all the disabled items' do
        within('#disabled-items') do
          expect(page).to have_content('Disabled Items')
          expect(page).to have_no_content('Enabled Items')

          merchant1_disabled_items.each do |item|
            expect(page).to have_content(item.name)
          end

          merchant1_enabled_items.each do |item|
            expect(page).to have_no_content(item.name)
          end
        end
      end

      it 'displays a button next to each item name to disable or enable that item' do
        merchant1_enabled_items.each do |item|
          within("#item-#{item.id}") do
            expect(page).to have_button('Disable')
            expect(page).to have_no_button('Enable')
          end
        end

        merchant1_disabled_items.each do |item|
          within("#item-#{item.id}") do
            expect(page).to have_button('Enable')
            expect(page).to have_no_button('Disable')
          end
        end
      end

      describe 'when I click on the enable button' do
        before do
          within("#item-#{item2.id}") { click_button 'Enable' }
        end

        it 'redirects me back to the merchant items index' do
          expect(current_path).to eq(merchant_items_path(merchant1))
        end

        it 'changes the items status' do
          expect(item2.status).to eq('disabled')

          item2.reload

          expect(item2.status).to eq('enabled')

          within '#enabled-items' do
            expect(page).to have_content(item2.name)
          end
        end
      end

      describe 'when I click on the disable button' do
        before do
          within("#item-#{item1.id}") { click_button 'Disable' }
        end

        it 'redirects me back to the merchant items index' do
          expect(current_path).to eq(merchant_items_path(merchant1))
        end

        it 'changes the items status' do
          expect(item1.status).to eq('enabled')

          item1.reload

          expect(item1.status).to eq('disabled')

          within '#disabled-items' do
            expect(page).to have_content(item1.name)
          end
        end
      end

      describe 'within the top 5 items section' do
        it 'displays the five most popular items by total revenue generated' do
          within '#top-items' do
            merchant1_top_items.each do |top_item|
              expect(page).to have_content(top_item.name)
            end

            expect(merchant1_top_items[0].name).to appear_before(merchant1_top_items[1].name)
            expect(merchant1_top_items[1].name).to appear_before(merchant1_top_items[2].name)
            expect(merchant1_top_items[2].name).to appear_before(merchant1_top_items[3].name)
            expect(merchant1_top_items[3].name).to appear_before(merchant1_top_items[4].name)

            expect(page).to have_no_content(item7.name)
          end
        end

        it 'links the top 5 to the item show page' do
          within '#top-items' do
            merchant1_top_items.each do |top_item|
              expect(page).to have_link(top_item.name)
            end

            click_link item1.name

            expect(current_path).to eq(merchant_item_path(merchant1, item1))
          end
        end

        it 'displays the total revenue next to each top item' do
          within '#top-items' do
            merchant1_top_items.each do |top_item|
              expect(page).to have_content(number_to_currency(top_item.total_revenue / 100.00))
            end
          end
        end

        it 'displays the best day next to each top item' do
          merchant1_top_items.each do |top_item|
            expect(page).to have_content("Top selling date for #{item1.name} was #{item1.best_day}")
          end
        end
      end
    end
  end
end
