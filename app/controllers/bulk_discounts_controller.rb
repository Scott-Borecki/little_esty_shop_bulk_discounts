class BulkDiscountsController < ApplicationController
  before_action :fetch_current_bulk_discount, only: [:edit, :show]
  before_action :fetch_current_merchant

  def index
  end

  def new
    @new_bulk_discount = BulkDiscount.new
  end

  def create
    @merchant.bulk_discounts.create!(bulk_discount_params)

    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def show
  end

  def edit
  end

  def update
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.update!(bulk_discount_params)
    redirect_to merchant_bulk_discount_path(@merchant, bulk_discount)
  end

  def destroy
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy!
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private

  def bulk_discount_params
    params.required(:bulk_discount).permit(:percentage_discount, :quantity_threshold)
  end

  def fetch_current_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def fetch_current_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end
end
