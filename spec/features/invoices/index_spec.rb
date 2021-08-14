require 'rails_helper'

describe "merchant invoices index (/merchant/:merchant_id/invoices)" do
  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }

  let!(:item1) { create(:item, merchant: merchant1) }
  let!(:item2) { create(:item, merchant: merchant1) }
  let!(:item3) { create(:item, merchant: merchant1) }
  let!(:item4) { create(:item, merchant: merchant1) }

  let!(:item5) { create(:item, merchant: merchant2) }
  let!(:item6) { create(:item, merchant: merchant2) }
  let!(:item7) { create(:item, merchant: merchant2) }
  let!(:item8) { create(:item, merchant: merchant2) }

  let!(:invoice_item1) {  create(:invoice_item, item: item1) }
  let!(:invoice_item2) {  create(:invoice_item, item: item1) }
  let!(:invoice_item3) {  create(:invoice_item, item: item2) }
  let!(:invoice_item4) {  create(:invoice_item, item: item3) }
  let!(:invoice_item6) {  create(:invoice_item, item: item4) }
  let!(:invoice_item7) {  create(:invoice_item, item: item7) }
  let!(:invoice_item8) {  create(:invoice_item, item: item8) }
  let!(:invoice_item9) {  create(:invoice_item, item: item4) }
  let!(:invoice_item10) { create(:invoice_item, item: item5) }

  describe 'as a merchant' do
    describe 'when I visit my merchants invoices index' do
      before { visit merchant_invoices_path(merchant1) }

      it { expect(page).to have_no_content('Success!') }
      it { expect(page).to have_no_content('Error!') }

      it 'displays all the invoices that include at least one of my merchant\'s items' do
        merchant1.invoices.each do |invoice|
          expect(page).to have_content(invoice.id)
        end
        merchant2.invoices.each do |invoice|
          expect(page).to have_no_content(invoice.id)
        end
      end

      it 'links each invoice id to the merchant invoice show page' do
        merchant1.invoices.each do |invoice|
          expect(page).to have_link("Invoice ##{invoice.id}")
        end

        merchant2.invoices.each do |invoice|
          expect(page).to have_no_link("Invoice ##{invoice.id}")
        end

        click_link "Invoice ##{merchant1.invoices.first.id}"

        expect(current_path).to eq(merchant_invoice_path(merchant1, merchant1.invoices.first))
      end
    end
  end
end
