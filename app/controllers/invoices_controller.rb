class InvoicesController < ApplicationController
  before_action :fetch_current_invoice, only: :show
  before_action :fetch_current_merchant, only: [:index, :show]

  def index
    @invoices = @merchant.invoices.uniq
  end

  def show
  end

  private

  def fetch_current_invoice
    @invoice = Invoice.find(params[:id])
  end

  def fetch_current_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
