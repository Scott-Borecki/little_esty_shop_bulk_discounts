class BulkDiscountsController < ApplicationController
  before_action :fetch_current_merchant, only: [:index, :show]

  def index
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  private

  def fetch_current_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
