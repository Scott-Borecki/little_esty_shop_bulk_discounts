class Admin::DashboardController < ApplicationController
  def index
    @top_customers = Customer.top_customers_by_transactions
    @incomplete_invoices = Invoice.incomplete_invoices
  end
end
