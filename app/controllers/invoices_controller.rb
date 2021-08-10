class InvoicesController < ApplicationController
  before_action :fetch_current_invoice, only: [:show, :update]
  before_action :fetch_current_merchant, only: [:index, :show, :update]

  def index
    @invoices = @merchant.invoices.uniq
  end

  def show
    @customer = @invoice.customer
  end

  # TODO: Add dynamic flash messages
  def update
    @invoice.update(invoice_params)

    redirect_to merchant_invoice_path(@merchant, @invoice)
  end

  private

  def invoice_params
    params.require(:invoice).permit(:status)
  end

  def fetch_current_invoice
    @invoice = Invoice.find(params[:id])
  end

  def fetch_current_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
