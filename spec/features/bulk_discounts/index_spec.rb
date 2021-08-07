require 'rails_helper'

RSpec.describe 'bulk discounts index page (/merchant/:merchant_id/bulk_discounts)' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Skin Care')

    @customer1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')

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

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice2.id)

    @bulk_discount1_1 = @merchant1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
    @bulk_discount1_2 = @merchant1.bulk_discounts.create!(percentage_discount: 15, quantity_threshold: 15)
    @bulk_discount1_3 = @merchant1.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 20)
    @bulk_discount2_1 = @merchant2.bulk_discounts.create!(percentage_discount: 12, quantity_threshold: 12)
    @bulk_discount2_2 = @merchant2.bulk_discounts.create!(percentage_discount: 14, quantity_threshold: 17)
    @bulk_discount2_3 = @merchant2.bulk_discounts.create!(percentage_discount: 22, quantity_threshold: 21)
  end

  describe 'as a merchant' do
    describe 'when I visit my merchant dashboard bulk discounts index (/merchant/:merchant_id/bulk_discounts)' do
      before { visit merchant_bulk_discounts_path(@merchant1) }

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

      it 'has a link to each bulk discount show page' do
        @merchant1.bulk_discounts.each do |bulk_discount|
          visit merchant_bulk_discounts_path(@merchant1)

          within "#bd-#{bulk_discount.id}" do
            expect(page).to have_link(bulk_discount.id.to_s)

            click_link bulk_discount.id.to_s

            expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, bulk_discount.id))
          end
        end
      end

      it 'has a link to create a new discount' do
        expect(page).to have_link('Create New Bulk Discount')

        click_link 'Create New Bulk Discount'

        expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
        expect(page).to have_field(:bulk_discount_percentage_discount)
        expect(page).to have_field(:bulk_discount_quantity_threshold)
        expect(page).to have_button('Create')
      end

      it 'has a link to delete each bulk discount' do
        link_text = 'Delete'

        @merchant1.bulk_discounts.each do |bulk_discount|
          visit merchant_bulk_discounts_path(@merchant1)

          within "#bd-#{bulk_discount.id}" do
            expect(page).to have_link(link_text)

            click_link link_text
          end

          expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
          expect(page).to have_no_css("#bd-#{bulk_discount.id}")
        end
      end
    end
  end
end
