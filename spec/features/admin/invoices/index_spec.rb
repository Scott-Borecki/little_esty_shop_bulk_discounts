require 'rails_helper'

describe 'admin invoices index (/admin/invoices)' do
  let!(:invoice1) { create(:invoice) }
  let!(:invoice2) { create(:invoice) }
  let!(:invoice3) { create(:invoice) }
  let!(:invoice4) { create(:invoice) }

  describe 'as an admin' do
    describe 'when I visit the admin invoices index' do
      before { visit admin_invoices_path }

      it 'displays a list of all invoice ids in the system as links' do
        Invoice.all.each do |invoice|
          expect(page).to have_link("Invoice ##{invoice.id}")
        end
      end

      it 'links to each admin invoice show page' do
        Invoice.all.each do |invoice|
          visit admin_invoices_path
          click_link "Invoice ##{invoice.id}"

          expect(current_path).to eq(admin_invoice_path(invoice))
        end
      end
    end
  end
end
