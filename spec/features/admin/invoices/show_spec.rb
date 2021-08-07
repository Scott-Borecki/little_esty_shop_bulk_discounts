require 'rails_helper'

describe 'admin invoice show page (/admin/invoices/:id)' do
  # See spec/object_creation_helper.rb for objection creation details
  admin_invoice_show_objects

  describe 'as an admin' do
    describe 'when I visit an admin invoice show page (/admin/invoices/:id)' do
      before { visit admin_invoice_path(invoice1) }

      it 'displays the invoice detials: id, status, and created_at' do
        expect(current_path).to eq(admin_invoice_path(invoice1))

        expect(page).to have_content("Invoice ##{invoice1.id}")
        expect(page).to have_content("Created on:\n#{invoice1.formatted_time}")

        expect(page).to have_no_content("Invoice ##{invoice2.id}")
      end

      it 'displays the customer details: name and address' do
        expect(page).to have_content("#{customer1.first_name} #{customer1.last_name}")
        expect(page).to have_content(customer1.address)
        expect(page).to have_content("#{customer1.city}, #{customer1.state} #{customer1.zip}")

        expect(page).to have_no_content("#{customer2.first_name} #{customer2.last_name}")
      end

      it 'displays all the items on the invoice and the item details: name, quantity, price, and status' do
        expect(page).to have_content(item1.name)
        expect(page).to have_content(item2.name)

        expect(page).to have_content(invoice_item1.quantity)
        expect(page).to have_content(invoice_item2.quantity)

        expect(page).to have_content(invoice_item1.unit_price)
        expect(page).to have_content(invoice_item2.unit_price)

        expect(page).to have_content(invoice_item1.status)
        expect(page).to have_content(invoice_item2.status)

        expect(page).to have_no_content(invoice_item3.quantity)
        expect(page).to have_no_content(invoice_item3.unit_price)
        expect(page).to have_no_content(invoice_item3.status)
      end

      it 'displays the total revenue' do
        expect(page).to have_content("Total Revenue:\n$#{invoice1.total_revenue}")

        expect(page).to have_no_content(invoice2.total_revenue)
      end

      it 'displays the total discounted' do
        expect(page).to have_content("Total Discounted Revenue:\n$#{invoice1.total_discounted_revenue}")

        expect(page).to have_no_content(invoice2.total_discounted_revenue)
      end

      it 'has a status select field that updates the invoices status' do
        within "#status-update-#{invoice1.id}" do
          expect(invoice1.status).to eq('completed')
          expect(page).to have_select('invoice[status]', selected: 'completed')
          expect(page).to have_button('Update Invoice')

          select 'cancelled', from: :invoice_status
          click_button 'Update Invoice'

          expect(current_path).to eq(admin_invoice_path(invoice1))
          expect(page).to have_select('invoice[status]', selected: 'cancelled')
          expect(invoice1.reload.status).to eq('cancelled')
        end
      end
    end
  end
end
