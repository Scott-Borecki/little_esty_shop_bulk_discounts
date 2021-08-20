class Admin::DashboardController < ApplicationController
  def index
    @incomplete_invoices = Invoice.incomplete_invoices.page(params[:page])
    @top_customers = Customer.top_customers
  end
end
