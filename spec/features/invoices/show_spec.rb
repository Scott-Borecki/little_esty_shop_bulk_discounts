require 'rails_helper'

RSpec.describe 'invoices show' do
  # See spec/object_creation_helper.rb for objection creation details
  create_factories

  before { visit merchant_invoice_path(merchant3, invoice3) }

  it "shows the invoice information" do
    expect(page).to have_content(invoice3.id)
    expect(page).to have_content(invoice3.status)
    expect(page).to have_content(invoice3.created_at.strftime("%A, %B %-d, %Y"))
  end

  it "shows the customer information" do
    expect(page).to have_content(customer3.first_name)
    expect(page).to have_content(customer3.last_name)
    expect(page).to_not have_content(customer2.last_name)
  end

  it "shows the item information" do
    expect(page).to have_content(item3.name)
    expect(page).to have_content(invoice_item3a.quantity)
    expect(page).to have_content(invoice_item3a.unit_price)

    expect(page).to have_content(item3a.name)
    expect(page).to have_content(invoice_item3b.quantity)
    expect(page).to have_content(invoice_item3b.unit_price)

    expect(page).to have_no_content(item4a.name)
    expect(page).to have_no_content(item5.name)
    expect(page).to have_no_content(item6.name)
  end

  it "shows the total revenue for this invoice" do
    expect(page).to have_content(invoice3.total_revenue)
  end

  it 'shows the total discounted revenue for this invoice' do
    expect(page).to have_content(invoice3.total_discounted_revenue)
  end

  it "shows a select field to update the invoice status" do
    within '#invoice-status' do
      expect(page).to have_content("Completed")
      expect(page).to_not have_content("In progress")
      expect(page).to_not have_content("Cancelled")
    end

    within "#the-status-#{invoice_item3a.id}" do
      page.select("cancelled")
      click_button "Update Invoice"
    end

    within '#invoice-status' do
      expect(page).to have_content("Cancelled")
      expect(page).to_not have_content("In progress")
      expect(page).to_not have_content("Completed")
    end
  end
end
