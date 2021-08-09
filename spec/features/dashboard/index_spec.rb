require 'rails_helper'

RSpec.describe 'merchant dashboard' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Skin Care')

    @customer1 = create(:customer)
    @customer2 = create(:customer)
    @customer3 = create(:customer)
    @customer4 = create(:customer)
    @customer5 = create(:customer)
    @customer6 = create(:customer)

    @invoice1 = Invoice.create!(customer_id: @customer1.id, status: 2)
    @invoice2 = Invoice.create!(customer_id: @customer1.id, status: 2)
    @invoice3 = Invoice.create!(customer_id: @customer2.id, status: 2)
    @invoice4 = Invoice.create!(customer_id: @customer3.id, status: 2)
    @invoice5 = Invoice.create!(customer_id: @customer4.id, status: 2)
    @invoice6 = Invoice.create!(customer_id: @customer5.id, status: 2)
    @invoice7 = Invoice.create!(customer_id: @customer6.id, status: 1)

    @item1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice2.id, item_id: @item3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice3.id, item_id: @item4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = create(:transaction, result: 1, invoice: @invoice1)
    @transaction2 = create(:transaction, result: 1, invoice: @invoice3)
    @transaction3 = create(:transaction, result: 1, invoice: @invoice4)
    @transaction4 = create(:transaction, result: 1, invoice: @invoice5)
    @transaction5 = create(:transaction, result: 1, invoice: @invoice6)
    @transaction6 = create(:transaction, result: 1, invoice: @invoice7)
    @transaction7 = create(:transaction, result: 1, invoice: @invoice2)

    @bulk_discount1_1 = @merchant1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
    @bulk_discount1_2 = @merchant1.bulk_discounts.create!(percentage_discount: 15, quantity_threshold: 15)
    @bulk_discount1_3 = @merchant1.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 20)
    @bulk_discount2_1 = @merchant2.bulk_discounts.create!(percentage_discount: 12, quantity_threshold: 12)
    @bulk_discount2_2 = @merchant2.bulk_discounts.create!(percentage_discount: 14, quantity_threshold: 17)
    @bulk_discount2_3 = @merchant2.bulk_discounts.create!(percentage_discount: 22, quantity_threshold: 21)
  end

  describe 'as a merchant' do
    describe 'when I visit my merchant dashboard (/merchant/:id/dashboard)' do
      before { visit merchant_dashboard_index_path(@merchant1) }

      it 'displays the name of my merchant' do
        expect(page).to have_content(@merchant1.name)
      end

      it 'displays a link to my merchant items index (/merchants/merchant_id/items)' do
        expect(page).to have_link("Items")

        click_link "Items"

        expect(current_path).to eq("/merchant/#{@merchant1.id}/items")
      end

      it 'displays a link to my merchant invoices index (/merchants/merchant_id/invoices)' do
        expect(page).to have_link("Invoices")

        click_link "Invoices"

        expect(current_path).to eq("/merchant/#{@merchant1.id}/invoices")
      end

      it 'displays a link to view all my discounts' do
        expect(page).to have_link('View All My Discounts')
      end

      describe 'when I click the View All My Discounts link' do
        before { click_link 'View All My Discounts' }

        it 'takes me to my bulk discounts index page' do
          allow(HolidayService).to receive(:holidays).and_return(holidays_parsed)
          expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
        end

        it 'displays all my bulk discounts: percentage discount and quantity thresholds' do
          within '#bulk-discounts' do
            @merchant1.bulk_discounts.each do |bulk_discount|
              expect(page).to have_content("Bulk Discount # #{bulk_discount.id}")
              expect(page).to have_content("#{bulk_discount.percentage_discount}% off")
              expect(page).to have_content("#{bulk_discount.quantity_threshold} item(s)")
            end

            @merchant2.bulk_discounts.each do |bulk_discount|
              expect(page).to have_no_content("Bulk Discount # #{bulk_discount.id}")
              expect(page).to have_no_content("#{bulk_discount.percentage_discount}% off")
              expect(page).to have_no_content("#{bulk_discount.quantity_threshold} item(s)")
            end
          end
        end

        it 'has a link to each bulk discount show page'
      end

      describe 'within the top five customers section' do
        it 'displays the names of the top 5 customers by number of transactions' do
          top_five_customers = @merchant1.top_customers_by_transactions

          within '#top-five-customers' do
            top_five_customers.each do |customer|
              expect(page).to have_content("#{customer.first_name} #{customer.last_name}")
            end
          end
        end

        it 'displays the number of transactions next to each customer' do
          top_five_customers = @merchant1.top_customers_by_transactions
          top_five_customers_transactions =
            top_five_customers.map do |customer|
              [customer.id, customer.number_transactions]
            end

          top_five_customers_transactions.each do |customer_id, number_transactions|
            within "#top-customer-#{customer_id}" do
              expect(page).to have_content(number_transactions)
            end
          end
        end
      end

      describe 'within the Items Ready to Ship section' do
        it 'displays list of the unshipped item names, the associated invoice id, and invoice creation date' do
          items_ready_to_ship = @merchant1.items_ready_to_ship

          within '#items_ready_to_ship' do
            items_ready_to_ship.each do |item|
              expect(page).to have_content(item.item_name)
              expect(page).to have_content(item.invoice_id)
              expect(page).to have_content(item.invoice_created_at.strftime('%A, %B %-d, %Y'))
            end
          end
        end

        it 'displays a link to the invoice show page' do
          items_ready_to_ship = @merchant1.items_ready_to_ship

          items_ready_to_ship.each do |item|
            visit merchant_dashboard_index_path(@merchant1)

            within "#ship-item-#{item.id}" do
              expect(page).to have_link(item.invoice_id.to_s)

              click_link item.invoice_id.to_s

              expect(current_path).to eq(merchant_invoice_path(@merchant1, item.invoice_id))
            end
          end
        end
      end
    end
  end
end
