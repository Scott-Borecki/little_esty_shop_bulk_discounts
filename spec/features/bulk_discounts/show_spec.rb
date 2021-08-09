require 'rails_helper'

RSpec.describe 'bulk discount show page (/merchant/:merchant_id/bulk_discounts/:id)' do
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
    describe 'when I visit my merchant dashboard bulk discount show (/merchant/:merchant_id/bulk_discounts/:id)' do
      before { visit merchant_bulk_discount_path(@merchant1, @bulk_discount1_1) }

      it 'displays the bulk discounts quantity threshold and percentage discount' do
        expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @bulk_discount1_1))

        expect(page).to have_content("Percentage Discount: #{@bulk_discount1_1.percentage_discount}%")
        expect(page).to have_content("Quantity Threshold: #{@bulk_discount1_1.quantity_threshold} item(s)")

        expect(page).to have_no_content("Percentage Discount: #{@bulk_discount1_2.percentage_discount}%")
        expect(page).to have_no_content("Quantity Threshold: #{@bulk_discount1_2.quantity_threshold} item(s)")
        expect(page).to have_no_content("Percentage Discount: #{@bulk_discount1_3.percentage_discount}%")
        expect(page).to have_no_content("Quantity Threshold: #{@bulk_discount1_3.quantity_threshold} item(s)")
      end

      it 'displays a link to edit the bulk discount' do
        expect(page).to have_link('Edit Bulk Discount')
      end

      describe 'when I click on the edit bulk discount link' do
        before { click_link('Edit Bulk Discount') }

        it 'takes me to a new page with a prepopulated form' do
          expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @bulk_discount1_1))
          expect(page).to have_field(:bulk_discount_percentage_discount, with: @bulk_discount1_1.percentage_discount)
          expect(page).to have_field(:bulk_discount_quantity_threshold, with: @bulk_discount1_1.quantity_threshold)
          expect(page).to have_button('Update')
        end
      end
    end
  end
end
