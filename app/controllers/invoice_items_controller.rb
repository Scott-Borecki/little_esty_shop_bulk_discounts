class InvoiceItemsController < ApplicationController
  def update
    invoice_item = InvoiceItem.find(params[:id])
    invoice_item.update!(invoice_item_params)

    flash.notice = 'Success! The invoice item was updated.'
    redirect_to URI(request.referer).path
  end

  private

  def invoice_item_params
    params.require(:invoice_item).permit(:status)
  end
end
