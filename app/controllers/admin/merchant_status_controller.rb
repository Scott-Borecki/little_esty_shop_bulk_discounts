class Admin::MerchantStatusController < ApplicationController
  before_action :fetch_current_merchant, only: [:update]

  # TODO: Add dynamic flash messages
  def update
    @merchant.update(merchant_status_params)

    flash.notice = 'Success! The merchant was updated.'
    redirect_to admin_merchants_path
  end

  private

  def fetch_current_merchant
    @merchant = Merchant.find(params[:id])
  end

  def merchant_status_params
    params.permit(:status)
  end
end
