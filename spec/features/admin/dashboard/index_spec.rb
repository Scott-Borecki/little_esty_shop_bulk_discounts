require 'rails_helper'

RSpec.describe 'admin dashboard index (/admin/dashboard)' do
  include ActionView::Helpers::NumberHelper

  # See /spec/sample_data/create_objects.rb for more info on factories created
  create_objects

  let(:top_customers) { Customer.top_customers }

  let(:shipped_invoices) do
    [invoice2a, invoice2b, invoice2c, invoice2d, invoice2e, invoice4a,
     invoice4b, invoice4c, invoice4d, invoice6a, invoice6b, invoice6c]
  end

  let(:not_shipped_invoices) { [invoice1, invoice3, invoice5a, invoice5b] }

  let(:not_shipped_invoices_ids) do
    [invoice1.id, invoice3.id, invoice5a.id, invoice5b.id]
  end

  let(:not_shipped_invoices_dates) do
    [invoice5a.formatted_date_short, invoice5b.formatted_date_short,
     invoice3.formatted_date_short, invoice1.formatted_date_short]
  end

  describe 'as an admin' do
    context 'when I visit the admin dashboard page' do
      before { visit admin_dashboard_index_path }

      it { expect(page).to have_current_path(admin_dashboard_index_path) }
      it { expect(page).to have_no_content('Success!') }
      it { expect(page).to have_no_content('Error!') }

      it 'displays a header indicating that I am on the admin dashboard' do
        expect(page).to have_content('Admin Dashboard')
      end

      it 'displays a link to the admin merchants index (/admin/merchants)' do
        expect(page).to have_link('Merchants')

        click_link 'Merchants'

        expect(page).to have_current_path(admin_merchants_path)
      end

      it 'displays a link to the admin merchants index (/admin/invoices)' do
        expect(page).to have_link('Invoices')

        click_link 'Invoices'

        expect(page).to have_current_path(admin_invoices_path)
      end

      context 'when I look in the top 5 customers section' do
        it 'displays the names and number of puchases of the top 5 customers' do
          expect(page).to have_content('Top Customers')

          top_customers.each do |customer|
            within "#top-customer-#{customer.id}" do
              expect(page).to have_content(customer.full_name)
              expect(page).to have_content(customer.transaction_count)
              expect(page).to have_content(customer.total_items)
              expect(page).to have_content(number_to_currency(customer.total_revenue / 100.00))
            end
          end
        end
      end

      context 'when I look in the incomplete invoices section' do
        it 'displays the details of each invoice with unshipped items' do
          not_shipped_invoices.each do |not_shipped_invoice|
            within "#invoice-#{not_shipped_invoice.id}" do
              expect(page).to have_content(not_shipped_invoice.id)
              expect(page).to have_content(not_shipped_invoice.formatted_date_short)
              expect(page).to have_content(number_to_currency(not_shipped_invoice.total_revenue / 100.00))
              expect(page).to have_content(number_to_currency(not_shipped_invoice.total_discounted_revenue / 100.00))

              unless not_shipped_invoice.revenue_discount == 0
                expect(page).to have_content(number_to_currency(-not_shipped_invoice.revenue_discount / 100.00))
              end

              expect(page).to have_select('invoice[status]', selected: 'Completed')
              expect(page).to have_button('Update')
            end
          end

          shipped_invoices.each do |shipped_invoice_id|
            expect(page).to have_no_content(shipped_invoice_id)
          end
        end

        it 'links the invoice ids to that invoices admin show page' do
          within '#incomplete-invoices' do
            not_shipped_invoices_ids.each do |not_shipped_invoice_id|
              expect(page).to have_link(not_shipped_invoice_id.to_s)
            end

            shipped_invoices.each do |shipped_invoice_id|
              expect(page).to have_no_link(shipped_invoice_id.to_s)
            end
          end
        end

        it 'displays the invoice date and sorts by oldest to newest' do
          not_shipped_invoices.each do |not_shipped_invoice|
            within "#invoice-#{not_shipped_invoice.id}" do
              expect(page).to have_content(not_shipped_invoice.formatted_date_short)
            end
          end

          within '#incomplete-invoices' do
            expect(not_shipped_invoices_dates[0]).to appear_before(not_shipped_invoices_dates[1])
            expect(not_shipped_invoices_dates[1]).to appear_before(not_shipped_invoices_dates[2])
            expect(not_shipped_invoices_dates[2]).to appear_before(not_shipped_invoices_dates[3])
          end
        end
      end

      context 'when I look in the Admin Metrics section' do
        it 'displays the admin metrics' do
          expect(page).to have_content('Admin Metrics')

          within '#admin-metrics' do
            expect(page).to have_content("Incomplete Invoices: #{Invoice.incomplete_invoices.size}")
          end
        end
      end
    end
  end
end
