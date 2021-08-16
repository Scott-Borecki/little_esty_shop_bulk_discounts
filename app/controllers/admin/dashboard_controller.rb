class Admin::DashboardController < ApplicationController
  def index
    @merchants = Merchant.all
    @top_customers = Customer.top_customers
    @invoices = Invoice.all
  end
end
