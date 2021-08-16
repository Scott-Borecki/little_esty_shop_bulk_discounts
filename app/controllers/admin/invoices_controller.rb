class Admin::InvoicesController < ApplicationController
  before_action :fetch_current_invoice, only: [:show, :edit, :update]

  def index
    @invoices = Invoice.all
  end

  def show
  end

  def edit
  end

  def update
    @invoice.update(invoice_params)

    flash.notice = 'Success! The invoice was updated.'
    redirect_to URI(request.referer).path
  end

  private

  def fetch_current_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:status)
  end
end
